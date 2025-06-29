class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :lottery

  validates :user_id, uniqueness: { scope: :lottery_id, message: "已经参与此抽签计划" }
  validates :virtual_users_count, numericality: { greater_than_or_equal_to: 0 }
  validates :joined_at, presence: true
  validates :status, presence: true

  enum :status, {
    active: "参与中",
    withdrawn: "已退出",
    suspended: "已暂停"
  }

  before_validation :set_defaults, on: :create
  before_save :update_virtual_users_count
  after_save :clear_lottery_cache
  after_destroy :clear_lottery_cache

  # 获取该用户在此Lottery中管理的虚拟用户
  def managed_virtual_users
    user.virtual_users
  end

  # 检查是否可以退出
  def can_withdraw?
    active? && lottery.status != "completed"
  end

  # 退出参与
  def withdraw!
    return false unless can_withdraw?
    update!(status: "withdrawn")
  end

  private

  def set_defaults
    self.joined_at ||= Time.current
    self.status ||= "active"
  end

  def update_virtual_users_count
    self.virtual_users_count = user.virtual_users.count
  end

  def clear_lottery_cache
    lottery.clear_virtual_users_count_cache
  end
end
