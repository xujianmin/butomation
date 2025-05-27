class Sites::PokermonsController < ApplicationController
  before_action :set_sites_pokermon, only: %i[ show edit update destroy ]

  # GET /sites/pokermons or /sites/pokermons.json
  def index
    @sites_pokermons = Sites::Pokermon.all
  end

  # GET /sites/pokermons/1 or /sites/pokermons/1.json
  def show
  end

  # GET /sites/pokermons/new
  def new
    # @sites_pokermon = Sites::Pokermon.new
    @sites_pokermon = Sites::Pokermon.new(virtual_user_id: params[:virtual_user_id])
    @virtual_user = VirtualUser.find(params[:virtual_user_id])
  end

  # GET /sites/pokermons/1/edit
  def edit
  end

  # POST /sites/pokermons or /sites/pokermons.json
  def create
    @sites_pokermon = Sites::Pokermon.new(sites_pokermon_params)
    @virtual_user = VirtualUser.find(params[:sites_pokermon][:virtual_user_id])

    respond_to do |format|
      if @sites_pokermon.save
        format.html { redirect_to virtual_user_path(@sites_pokermon.virtual_user), notice: "Pokermon was successfully created." }
        format.json { render :show, status: :created, location: @sites_pokermon }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sites_pokermon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sites/pokermons/1 or /sites/pokermons/1.json
  def update
    respond_to do |format|
      if @sites_pokermon.update(sites_pokermon_params)
        format.html { redirect_to @sites_pokermon, notice: "Pokermon was successfully updated." }
        format.json { render :show, status: :ok, location: @sites_pokermon }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sites_pokermon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/pokermons/1 or /sites/pokermons/1.json
  def destroy
    @sites_pokermon.destroy!

    respond_to do |format|
      format.html { redirect_to sites_pokermons_path, status: :see_other, notice: "Pokermon was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def register
    @sites_pokermon = Sites::Pokermon.find(params.expect(:id))
    @virtual_user = @sites_pokermon.virtual_user
  end

  def login
  end

  def revise_activated_cellphone_and_maintained_password
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sites_pokermon
      @sites_pokermon = Sites::Pokermon.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def sites_pokermon_params
      params.expect(sites_pokermon: [ :nickname, :kana, :registry_cellphone, :registry_postcode, :registry_fandi, :reg_password, :virtual_user_id ])
    end
end
