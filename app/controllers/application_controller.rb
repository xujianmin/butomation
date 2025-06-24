class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :check_session_expiry, if: :should_check_session_expiry?

  private

  def should_check_session_expiry?
    # 只在需要认证的控制器中检查会话过期
    !self.class.instance_variable_get(:@skip_authentication)
  end

  def check_session_expiry
    # 直接检查cookie中的会话，而不是Current.session
    session = Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]

    if session&.expired?
      # 会话已过期，清理cookie和数据库记录
      cookies.delete(:session_id)
      session.destroy
      # 清理可能的重定向URL
      session.delete(:return_to_after_authenticating)
      redirect_to new_session_path, alert: "会话已过期，请重新登入"
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
