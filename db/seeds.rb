# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# 创建默认超级管理员用户
User.find_or_create_by!(email_address: "admin@usingnow.tech") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.role = "root"
end

# 为现有用户设置默认角色（如果没有设置的话）
User.where(role: nil).update_all(role: "user")
