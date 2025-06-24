class UsersController < ApplicationController
  before_action :require_root, only: [ :index, :new, :create, :edit, :update, :assign_virtual_users, :assign_virtual_users_post ]
  before_action :set_user, only: [ :show, :edit, :update, :assign_virtual_users, :assign_virtual_users_post ]

  # GET /users
  def index
    @users = User.regular_users
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(user_params)
    @user.role = "user" # 新用户只能是普通用户

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "用户创建成功" }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "用户更新成功" }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/1/assign_virtual_users
  def assign_virtual_users
    @filters = params[:filters] || {}

    # 获取未分配的虚拟用户
    @unassigned_virtual_users = VirtualUser.left_joins(:subordinations)
                                          .where(subordinations: { id: nil })
                                          .search(@filters["query"])
                                          .sorted(@filters["sort"])
                                          .by_civ_style(@filters["civ_style"])
                                          .page(params[:page])
                                          .per(20)

    # 获取当前用户已分配的虚拟用户
    @assigned_virtual_users = @user.virtual_users.page(params[:assigned_page]).per(20)
  end

  # PATCH /users/1/assign_virtual_users
  def assign_virtual_users_post
    virtual_user_ids = params[:virtual_user_ids] || []

    if virtual_user_ids.any?
      virtual_users = VirtualUser.where(id: virtual_user_ids)
      virtual_users.each do |virtual_user|
        @user.assign_virtual_user(virtual_user)
      end

      redirect_to assign_virtual_users_user_path(@user), notice: "成功分配 #{virtual_users.count} 个虚拟用户"
    else
      redirect_to assign_virtual_users_user_path(@user), alert: "请选择要分配的虚拟用户"
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email_address, :password, :password_confirmation, :role)
    end
end
