class AttendancesController < ApplicationController
  before_action :set_lottery

  def new
    @users = User.where.not(id: @lottery.participants.pluck(:id))
    @attendance = @lottery.attendances.new
  end

  def create
    user_ids = attendance_params[:user_ids].reject(&:blank?)

    if user_ids.empty?
      @users = User.where.not(id: @lottery.participants.pluck(:id))
      @attendance = @lottery.attendances.new
      flash.now[:alert] = "请至少选择一个用户"
      render :new, status: :unprocessable_entity
      return
    end

    success_count = 0
    user_ids.each do |user_id|
      user = User.find(user_id)
      next if @lottery.participated_by?(user)

      attendance = @lottery.attendances.new(user_id: user_id, joined_at: Time.current)
      if attendance.save
        success_count += 1
      end
    end

    if success_count > 0
      redirect_to @lottery, notice: "成功添加 #{success_count} 个参与人！"
    else
      @users = User.where.not(id: @lottery.participants.pluck(:id))
      @attendance = @lottery.attendances.new
      flash.now[:alert] = "添加参与人失败"
      render :new, status: :unprocessable_entity
    end
  end

  private
  def set_lottery
    @lottery = Lottery.find(params[:lottery_id])
  end

  def attendance_params
    params.require(:attendance).permit(user_ids: [])
  end
end
