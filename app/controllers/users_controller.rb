class UsersController < ApplicationController
  include ErrorConstants
  include SwaggerDocs::UsersController

  wrap_parameters :user, include: [:name, :role, :email, :password, :password_confirmation]

  # GET /users
  def index
    @users = paginate model, page: page, per_page: per_page
    render json: @users.map(&:facade), status: :ok
  end

  # GET /users/1
  def show
    render json: @user.facade
  end

  # POST /users
  def create
    @user = model.new(user_params)

    if @user.save
      UserMailer.welcome_email(@user).deliver_now
      render json: @user.facade, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user.facade
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

    def model
      @current_account.users
    end

    def write_actions
      %i(create update)
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :role, :email, :password, :password_confirmation)
    end
end
