class Lottery < ApplicationRecord
  belongs_to :user  # 创建者

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

  # 参与关系
  has_many :attendances, dependent: :destroy
  has_many :participants, through: :attendances, source: :user

  # 获取所有参与的虚拟用户
  def all_participating_virtual_users
    VirtualUser.joins(users: :attendances)
               .where(attendances: { lottery_id: id, status: "active" })
               .distinct
  end

  # 获取活跃参与者
  def active_participants
    participants.joins(:attendances)
                .where(attendances: { lottery_id: id, status: "active" })
                .distinct
  end

  # 检查用户是否参与
  def participated_by?(user)
    participants.include?(user)
  end

  # 检查用户是否活跃参与
  def actively_participated_by?(user)
    attendances.exists?(user: user, status: "active")
  end

  # 添加参与者
  def add_participant(user)
    return false if participated_by?(user)
    attendances.create!(user: user)
  end

  # 移除参与者
  def remove_participant(user)
    attendance = attendances.find_by(user: user)
    attendance&.withdraw!
  end

  # 获取参与者统计
  def participants_count
    active_participants.count
  end

  # 获取虚拟用户统计
  def virtual_users_count
    all_participating_virtual_users.count
  end

  # 获取总共参与虚拟用户数（所有参与人的虚拟用户总数）
  def total_participating_virtual_users_count
    # 使用数据库聚合查询，避免N+1问题
    Attendance.joins(:user)
              .joins("INNER JOIN subordinations ON users.id = subordinations.user_id")
              .joins("INNER JOIN virtual_users ON subordinations.virtual_user_id = virtual_users.id")
              .where(lottery_id: id, status: "active")
              .count("virtual_users.id")
  end

  # 获取总共参与虚拟用户数（带缓存版本，适用于频繁访问）
  def cached_total_participating_virtual_users_count
    Rails.cache.fetch("lottery_#{id}_total_virtual_users_count", expires_in: 5.minutes) do
      total_participating_virtual_users_count
    end
  end

  # 清除虚拟用户数缓存
  def clear_virtual_users_count_cache
    Rails.cache.delete("lottery_#{id}_total_virtual_users_count")
  end

  # 获取参与者的虚拟用户分布统计
  def participants_virtual_users_distribution
    Attendance.joins(:user)
              .joins("LEFT JOIN subordinations ON users.id = subordinations.user_id")
              .where(lottery_id: id, status: "active")
              .group("users.id, users.email_address")
              .count("subordinations.virtual_user_id")
  end

  # 获取参与虚拟用户数最多的前N个用户
  def top_virtual_users_participants(limit = 5)
    Attendance.joins(:user)
              .joins("LEFT JOIN subordinations ON users.id = subordinations.user_id")
              .where(lottery_id: id, status: "active")
              .group("users.id, users.email_address")
              .order("COUNT(subordinations.virtual_user_id) DESC")
              .limit(limit)
              .pluck("users.email_address", "COUNT(subordinations.virtual_user_id)")
  end

  # 获取按domain分组的虚拟用户统计
  def virtual_users_by_domain
    VirtualUser.joins(users: :attendances)
               .where(attendances: { lottery_id: id, status: "active" })
               .group(:domain)
               .count
  end

  # 获取按domain分组的虚拟用户详细信息
  def virtual_users_by_domain_with_details
    VirtualUser.joins(users: :attendances)
               .where(attendances: { lottery_id: id, status: "active" })
               .group(:domain)
               .select(:domain, "COUNT(*) as count")
               .order("count DESC")
  end

  # 获取domain统计的百分比分布
  def virtual_users_domain_distribution
    total = total_participating_virtual_users_count
    return {} if total == 0

    virtual_users_by_domain.transform_values do |count|
      {
        count: count,
        percentage: (count.to_f / total * 100).round(1)
      }
    end
  end
end
