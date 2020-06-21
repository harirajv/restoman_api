class AuthenticationController < ApplicationController
  skip_before_action :authenticate!, on: [:login, :forgot, :reset]
  before_action :set_user, on: [:login, :forgot, :reset]

  include ActionController::ImplicitRender
  include ApplicationConstants
  include ErrorConstants

  # POST /login
  def login
    if @user.authenticate(login_params[:password])
      @token = JsonWebToken.encode({ user_id: @user.id, role: @user.role })
      render status: :ok
    else
      render json: { errors: [ERROR_MESSAGES[:invalid_password]] }, status: :unauthorized
    end
  end

  def forgot
    @user.generate_password_token!
    UserMailer.reset_password_email(@user).deliver_later
    render json: {}, status: :ok
  rescue => e
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  def reset
    if login_params[:token].nil? || !@user.password_token_valid?
      render json: { errors: [ERROR_MESSAGES[:token_expired]] }, status: :bad_request
      return
    end

    @user.reset_password!(login_params[:password])
    render json: {}, status: :ok
  rescue => e
      render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  private

    def model
      # Not relevant
    end

    def login_params
      params.permit(:email, :password, :token)
    end

    def set_user
      @user = User.find_by_email(login_params[:email])
      if @user.nil?
        render json: { errors: [ERROR_MESSAGES[:invalid_user_email] % login_params[:email]] }, status: :not_found
        return
      end
    end
end
