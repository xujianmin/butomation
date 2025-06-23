class Subordination < ApplicationRecord
  belongs_to :user
  belongs_to :virtual_user

  # 防止重复关联
  validates :user_id, uniqueness: { scope: :virtual_user_id, message: "该虚拟用户已经被分配给此用户" }

  # 确保关联存在
  validates :user, presence: true
  validates :virtual_user, presence: true
end
