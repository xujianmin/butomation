class LotteriesController < ApplicationController
  before_action :set_lottery, only: %i[ show edit update destroy ]

  # GET /lotteries or /lotteries.json
  def index
    @lotteries = Lottery.all
  end

  # GET /lotteries/1 or /lotteries/1.json
  def show
    # 预加载关联数据以提高性能
    @lottery = Lottery.includes(:user, attendances: :user).find(params[:id])

    # 计算总共参与虚拟用户数（使用缓存版本）
    @total_participating_virtual_users_count = @lottery.cached_total_participating_virtual_users_count

    # 获取参与者虚拟用户分布统计
    @participants_virtual_users_distribution = @lottery.participants_virtual_users_distribution

    # 获取虚拟用户数最多的前5个参与者
    @top_virtual_users_participants = @lottery.top_virtual_users_participants(5)

    # 获取所有参与虚拟用户的详细信息
    @all_participating_virtual_users = @lottery.all_participating_virtual_users.includes(:user)

    # 按参与者分组的虚拟用户
    @virtual_users_by_participant = @lottery.active_participants.map do |participant|
      {
        participant: participant,
        virtual_users: participant.virtual_users,
        count: participant.virtual_users.count
      }
    end.sort_by { |data| -data[:count] }
  end

  # GET /lotteries/1/statistics
  def statistics
    @lottery = Lottery.find(params[:id])

    # 计算各种统计数据
    @total_participating_virtual_users_count = @lottery.cached_total_participating_virtual_users_count
    @participants_virtual_users_distribution = @lottery.participants_virtual_users_distribution
    @top_virtual_users_participants = @lottery.top_virtual_users_participants(10)
    @active_participants_count = @lottery.active_participants.count

    # 按domain统计的虚拟用户数据
    @virtual_users_by_domain = @lottery.virtual_users_by_domain
    @virtual_users_domain_distribution = @lottery.virtual_users_domain_distribution
    @top_domains = @lottery.virtual_users_by_domain_with_details.limit(5)

    respond_to do |format|
      format.html
      format.json { render json: {
        total_virtual_users: @total_participating_virtual_users_count,
        active_participants: @active_participants_count,
        distribution: @participants_virtual_users_distribution,
        top_participants: @top_virtual_users_participants,
        domain_distribution: @virtual_users_domain_distribution,
        top_domains: @top_domains
      } }
    end
  end

  # GET /lotteries/new
  def new
    @lottery = Lottery.new
  end

  # GET /lotteries/1/edit
  def edit
  end

  # POST /lotteries or /lotteries.json
  def create
    @lottery = Lottery.new(lottery_params)

    respond_to do |format|
      if @lottery.save
        format.html { redirect_to @lottery, notice: "Lottery was successfully created." }
        format.json { render :show, status: :created, location: @lottery }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lottery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lotteries/1 or /lotteries/1.json
  def update
    respond_to do |format|
      if @lottery.update(lottery_params)
        format.html { redirect_to @lottery, notice: "Lottery was successfully updated." }
        format.json { render :show, status: :ok, location: @lottery }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lottery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lotteries/1 or /lotteries/1.json
  def destroy
    @lottery.destroy!

    respond_to do |format|
      format.html { redirect_to lotteries_path, status: :see_other, notice: "Lottery was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lottery
      @lottery = Lottery.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def lottery_params
      params.require(:lottery).permit(
        :title,
        :started_at,
        :ended_at,
        :target_url,
        :user_id,
        :priority,
        :status,
        :meeting_url,
        :meeting_code
      )
    end
end
