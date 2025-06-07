crumb :root do
  link "首页", root_path
end

# 虚拟用户相关
crumb :virtual_users do
  link "虚拟用户", virtual_users_path
  parent :root
end

crumb :virtual_user do |virtual_user|
  link virtual_user.fullname, virtual_user_path(virtual_user)
  parent :virtual_users
end

crumb :new_virtual_user do
  link "新增虚拟用户", new_virtual_user_path
  parent :virtual_users
end

crumb :edit_virtual_user do |virtual_user|
  link "编辑 #{virtual_user.fullname}", edit_virtual_user_path(virtual_user)
  parent :virtual_user, virtual_user
end

# 宝可梦相关
crumb :pokermons do
  link "宝可梦", sites_pokermons_path
  parent :root
end

crumb :pokermon do |pokermon|
  link pokermon.name, sites_pokermon_path(pokermon)
  parent :pokermons
end

crumb :new_pokermon do
  link "新增宝可梦", new_sites_pokermon_path
  parent :pokermons
end

crumb :edit_pokermon do |pokermon|
  link "编辑 #{pokermon.name}", edit_sites_pokermon_path(pokermon)
  parent :pokermon, pokermon
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
