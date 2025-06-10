class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "重试次数过多，请稍后再试！" }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      session[:expires_at] = 15.minutes.from_now
      redirect_to after_authentication_url, notice: "登入成功!"
    else
      redirect_to new_session_path, alert: "邮箱地址或密码错误！"
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, notice: "已退出登入"
  end
end
