class AuthenticationController < ApplicationController
  before_action :set_user, only: [:login, :forgot, :reset]

  include ApplicationConstants
  include ErrorConstants
  include Concerns::SwaggerDocs::AuthenticationController

  # POST /login
  def login
    if @user.authenticate(login_params[:password])
      @token = JsonWebToken.encode({ user_id: @user.id, role: @user.role })
      Redis.current.set(@token, @user.id)
      Redis.current.expire(@token, JWT_EXPIRY_TIME)
      render json: { user: @user.facade, token: @token }, status: :ok
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

  def logout
    Redis.current.del(@token)
    Rails.logger.info "#{@current_user.email} has logged out"
    head :no_content
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

    def authenticate!
      return unless action_name == 'logout'

      @token = request.headers['Authorization']
      @decoded = JsonWebToken.decode(@token)
      @current_user = User.find(@decoded[:user_id]) if @decoded
    rescue => e
      Rails.logger.error "JWT decode failed - #{e.message} token - #{@token}"
      head :reset_content
    end
end
