class LotteriesController < ApplicationController
  before_action :set_lottery, only: %i[ show edit update destroy ]

  # GET /lotteries or /lotteries.json
  def index
    @lotteries = Lottery.all
  end

  # GET /lotteries/1 or /lotteries/1.json
  def show
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
      params.expect(lottery: [
        :title,
        :started_at,
        :ended_at,
        :target_url,
        :user_id,
        :owner_id,
        :priority,
        :status,
        :meeting_url,
        :meeting_code
      ])
    end
end
