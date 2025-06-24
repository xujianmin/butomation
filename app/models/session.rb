class Session < ApplicationRecord
  belongs_to :user

  # 检查会话是否过期
  def expired?
    expires_at && expires_at < Time.current
  end

  # 设置过期时间
  def set_expires_at(duration = 15.minutes)
    update(expires_at: duration.from_now)
  end

  # 延长会话
  def extend_session(duration = 15.minutes)
    set_expires_at(duration)
  end

  # 清理过期会话
  def self.cleanup_expired
    where("expires_at < ?", Time.current).destroy_all
  end

  # 获取活跃会话
  scope :active, -> { where("expires_at > ? OR expires_at IS NULL", Time.current) }
end
