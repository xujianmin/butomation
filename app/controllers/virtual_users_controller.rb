class VirtualUsersController < ApplicationController
  include Filterable

  before_action :set_virtual_user, only: %i[ show edit update destroy ]

  # GET /virtual_users or /virtual_users.json
  def index
    # @virtual_users = VirtualUser.all
    # if search_params.present?
    #   @virtual_users = VirtualUser.includes(:pokermon)
    #   # @virtual_users = @virtual_users.where("last_name LIKE ? OR first_name LIKE ? OR email LIKE ?", "%#{search_params[:query]}%", "%#{search_params[:query]}%", "%#{search_params[:query]}%") if search_params[:query].present?
    #   @virtual_users = @virtual_users.text_search(search_params[:query]) if search_params[:query].present?

    #   if search_params[:sort].present?
    #     sort = search_params[:sort].split("-")
    #     @virtual_users = @virtual_users.order("#{sort[0]} #{sort[1]}")
    #   end
    # else
    #   @virtual_users = VirtualUser.includes(:pokermon).all
    # end

    @virtual_users = filter!(VirtualUser)
  end

  # GET /virtual_users/1 or /virtual_users/1.json
  def show
  end

  # GET /virtual_users/new
  def new
    @virtual_user = VirtualUser.new
    @virtual_user.randomize_virtual_user
  end

  # GET /virtual_users/1/edit
  def edit
  end

  # POST /virtual_users or /virtual_users.json
  def create
    @virtual_user = VirtualUser.new(virtual_user_params)

    respond_to do |format|
      if @virtual_user.save
        format.html { redirect_to @virtual_user, notice: "Virtual user was successfully created." }
        format.json { render :show, status: :created, location: @virtual_user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @virtual_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /virtual_users/1 or /virtual_users/1.json
  def update
    respond_to do |format|
      if @virtual_user.update(virtual_user_params)
        format.html { redirect_to @virtual_user, notice: "Virtual user was successfully updated." }
        format.json { render :show, status: :ok, location: @virtual_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @virtual_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /virtual_users/1 or /virtual_users/1.json
  def destroy
    @virtual_user.destroy!

    respond_to do |format|
      format.html { redirect_to virtual_users_path, status: :see_other, notice: "Virtual user was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_virtual_user
      @virtual_user = VirtualUser.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def virtual_user_params
      params.expect(virtual_user: [ :last_name, :first_name, :gender, :email, :civ_style, :birthdate, :domain ])
    end

    def search_params
      params.permit(:query, :sort)
    end
end
