class Lottery < ApplicationRecord
  belongs_to :user
  belongs_to :owner, class_name: "User", optional: true

  before_validation :set_default_owner, on: :create

  validates :title, :target_url, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  # 设置默认值
  attribute :priority, :string, default: "normal"
  attribute :status, :string, default: "planned"

  enum :priority, {
    high: "超级优先",
    normal: "优先",
    low: "正常"
  }

  enum :status, {
    pending: "等待中",
    planned: "已计划，待执行",
    active: "执行中",
    completed: "已完成",
    cancelled: "已取消"
  }

  private

  def set_default_owner
    self.owner_id ||= Current.user&.id
  end
end
