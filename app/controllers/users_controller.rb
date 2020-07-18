class UsersController < ApplicationController
  before_action :validate_user, only: [:create, :update]

  include UsersConstants
  include ErrorConstants
  include Concerns::SwaggerDocs::UsersController

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
    @user = User.new(user_params)

    if @user.save
      UserMailer.welcome_email(@user).deliver_now
      render json: @user.facade, status: :created
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
      render json: @user.facade
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
