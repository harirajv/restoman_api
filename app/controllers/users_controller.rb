class UsersController < ApplicationController
  before_action :validate_user, only: [:create, :update]

  include UsersConstants
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
    unallowed_fields = user_params.keys - UPDATE_ALLOWED_FIELDS[@current_user.role]
    if unallowed_fields.present?
      render json: { errors: [ERROR_MESSAGES[:update_not_allowed] % unallowed_fields.join(', ')] }, status: :forbidden
      return
    end

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
      render json: { errors: [ERROR_MESSAGES[:not_privileged]] },
              status: :forbidden if RESTRICTED_ACTIONS[@current_user.role].include?(action_name)
    end
end
