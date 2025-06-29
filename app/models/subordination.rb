class Subordination < ApplicationRecord
  belongs_to :user
  belongs_to :virtual_user

  # 防止重复关联
  validates :user_id, uniqueness: { scope: :virtual_user_id, message: "该虚拟用户已经被分配给此用户" }

  # 确保关联存在
  validates :user, presence: true
  validates :virtual_user, presence: true

  # 当虚拟用户分配关系改变时，清除相关抽签计划的缓存
  after_save :clear_related_lottery_cache
  after_destroy :clear_related_lottery_cache

  private

  def clear_related_lottery_cache
    # 清除该用户参与的所有活跃抽签计划的缓存
    user.attendances.where(status: "active").each do |attendance|
      attendance.lottery.clear_virtual_users_count_cache
    end
  end
end
