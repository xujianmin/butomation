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
    @sites_pokermon = Sites::Pokermon.new
  end

  # GET /sites/pokermons/1/edit
  def edit
  end

  # POST /sites/pokermons or /sites/pokermons.json
  def create
    @sites_pokermon = Sites::Pokermon.new(sites_pokermon_params)

    respond_to do |format|
      if @sites_pokermon.save
        format.html { redirect_to @sites_pokermon, notice: "Pokermon was successfully created." }
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
