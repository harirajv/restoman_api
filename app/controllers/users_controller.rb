class UsersController < ApplicationController
  before_action :validate_user, only: [:create, :update]

  include ErrorConstants

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

    def model
      User
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.permit(:name, :role, :email, :password, :password_confirmation)
    end

    def validate_user
      render json: { errors: [ERROR_MESSAGES[:not_privileged]] }, status: :forbidden unless @current_user.admin?
    end
end
