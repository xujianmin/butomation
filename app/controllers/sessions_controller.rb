class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create heartbeat ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "重试次数过多，请稍后再试！" }

  def new
  end

  def create
    if user = User.authenticate_by(session_params.slice(:email_address, :password))
      # 强制清理可能残留的重定向URL
      session.delete(:return_to_after_authenticating)

      start_new_session_for user
      Current.session.set_expires_at(15.minutes)

      if session_params[:remember_me]
        cookies.signed[:remembered_email] = {
          value: session_params[:email_address],
          expires: 24.hours.from_now,
          httponly: true,
          secure: Rails.env.production?,
          path: "/",
          domain: :all
        }
        cookies.signed[:remember_me] = {
          value: true,
          expires: 24.hours.from_now,
          httponly: true,
          secure: Rails.env.production?,
          path: "/",
          domain: :all
        }
      else
        cookies.delete(:remembered_email)
        cookies.delete(:remember_me)
      end

      redirect_to after_authentication_url, notice: "登入成功!"
    else
      redirect_to new_session_path, alert: "邮箱地址或密码错误！"
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, notice: "已退出登入"
  end

  # 心跳请求 - 更新会话过期时间
  def heartbeat
    # 检查当前会话是否有效
    if Current.session&.expired?
      render json: { error: "Session expired" }, status: :unauthorized
      return
    end

    # 只有未过期的会话才延长
    if Current.user && Current.session
      Current.session.extend_session(5.minutes)
      render json: { status: "ok" }
    else
      render json: { error: "Not authenticated" }, status: :unauthorized
    end
  end

  private

  def session_params
    params.permit(:email_address, :password, :remember_me, :authenticity_token, :commit)
  end
end
