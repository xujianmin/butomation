class UsersController < ApplicationController
  before_action :require_root, only: [ :index, :new, :create, :edit, :update ]
  before_action :set_user, only: [ :show, :edit, :update ]

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

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email_address, :password, :password_confirmation, :role)
    end
end
