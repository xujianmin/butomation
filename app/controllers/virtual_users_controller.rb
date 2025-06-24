class VirtualUsersController < ApplicationController
  include Filterable

  before_action :set_virtual_user, only: %i[ show edit update destroy ]
  before_action :require_virtual_user_access, only: %i[ show edit update destroy ]

  # GET /virtual_users or /virtual_users.json
  def index
    # 根据用户角色过滤虚拟用户
    base_query = Current.user.manageable_virtual_users
    @virtual_users = filter!(VirtualUser, base_query)
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
        # 自动分配给当前用户。只有普通用户需要自动分配, 超级管理员生成的用户默认留空。
        Current.user.assign_virtual_user(@virtual_user) unless Current.user.role_root?

        format.html { redirect_to @virtual_user, notice: "虚拟用户创建成功" }
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
        format.html { redirect_to @virtual_user, notice: "虚拟用户更新成功" }
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
      format.html { redirect_to virtual_users_path, status: :see_other, notice: "虚拟用户删除成功" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_virtual_user
      @virtual_user = VirtualUser.find(params.expect(:id))
    end

    # 权限检查方法
    def require_virtual_user_access
      unless Current.user&.can_manage_own_virtual_user?(@virtual_user)
        redirect_to virtual_users_path, alert: "您没有权限访问此虚拟用户"
      end
    end

    # Only allow a list of trusted parameters through.
    def virtual_user_params
      params.expect(virtual_user: [ :last_name, :first_name, :gender, :email, :civ_style, :birthdate, :domain ])
    end

    def search_params
      params.permit(:query, :sort)
    end
end
