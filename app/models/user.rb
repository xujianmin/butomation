class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :lotteries, dependent: :destroy

  # 与VirtualUser的多对多关联
  has_many :subordinations, dependent: :destroy
  has_many :virtual_users, through: :subordinations

  # 角色枚举定义 - 只保留 root 和 user
  enum :role, {
    "user" => "普通用户",
    "root" => "超级管理员"
  }

  # Scope 定义
  scope :regular_users, -> { where(role: "user") }
  scope :super_admins, -> { where(role: "root") }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # 手动添加角色检查方法
  def role_user?
    role == "user"
  end

  def role_root?
    role == "root"
  end

  # 获取角色显示文本
  def role_text
    self.class.roles[role]
  end

  # 权限检查方法
  def can_manage_virtual_users?
    role_root?
  end

  def can_manage_all_virtual_users?
    role_root?
  end

  def can_manage_users?
    role_root?
  end

  def can_manage_lotteries?
    role_root?
  end

  def can_manage_system?
    role_root?
  end

  def can_view_users?
    role_root?
  end

  def can_create_lottery?
    true  # 所有用户都可以创建抽签计划
  end

  def can_manage_own_lottery?(lottery)
    lottery.user_id == id || role_root?
  end

  def can_manage_own_virtual_user?(virtual_user)
    virtual_users.include?(virtual_user) || role_root?
  end

  # 获取可管理的虚拟用户
  def manageable_virtual_users
    if role_root?
      VirtualUser.all
    else
      virtual_users
    end
  end

  # 获取可管理的抽签计划
  def manageable_lotteries
    if role_root?
      Lottery.all
    else
      lotteries
    end
  end

  # 角色升级检查 - 只有 root 可以提升用户为 root
  def can_promote_to?(target_role)
    return false unless role_root?
    return false if target_role == "root" && User.where(role: "root").count >= 1
    true
  end

  # 角色降级检查
  def can_demote_user?(target_user)
    return false unless role_root?
    return false if target_user.role_root? && User.where(role: "root").count <= 1
    true
  end

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
