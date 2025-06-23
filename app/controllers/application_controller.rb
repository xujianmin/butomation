class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # before_action :authenticate
  before_action :check_session_expiry

  private

  def check_session_expiry
    if session[:expires_at] && session[:expires_at] < Time.current
      terminate_session
      redirect_to new_session_path, alert: "会话已过期，请重新登录"
    end
  end

  def terminate_session
    Current.session&.destroy
    cookies.delete(:session_id)
    session.clear
  end

  # 权限检查方法
  def require_root
    unless Current.user&.role_root?
      redirect_to root_path, alert: "需要超级管理员权限"
    end
  end

  def require_lottery_access(lottery)
    unless Current.user&.can_manage_own_lottery?(lottery)
      redirect_to lotteries_path, alert: "您没有权限访问此抽签计划"
    end
  end
end
