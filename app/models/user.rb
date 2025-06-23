class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :lotteries, dependent: :destroy

  # 与VirtualUser的多对多关联
  has_many :subordinations, dependent: :destroy
  has_many :virtual_users, through: :subordinations

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # 分配虚拟用户给当前用户
  def assign_virtual_user(virtual_user)
    virtual_users << virtual_user unless virtual_users.include?(virtual_user)
  end

  # 移除虚拟用户分配
  def remove_virtual_user(virtual_user)
    virtual_users.delete(virtual_user)
  end

  # 检查是否管理某个虚拟用户
  def manages_virtual_user?(virtual_user)
    virtual_users.include?(virtual_user)
  end
end
