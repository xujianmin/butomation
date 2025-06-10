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
end
