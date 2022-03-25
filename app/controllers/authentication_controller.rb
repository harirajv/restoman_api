class AuthenticationController < ApplicationController
  before_action :set_user, only: [:login, :forgot, :reset]

  include ApplicationConstants
  include ErrorConstants
  include SwaggerDocs::AuthenticationController

  # POST /login
  def login
    if @current_user.authenticate(login_params[:password])
      @token = JsonWebToken.generate_token @current_user
      render json: { user: @current_user.facade, token: @token }, status: :ok
    else
      render json: { errors: [ERROR_MESSAGES[:invalid_password]] }, status: :unauthorized
    end
  end

  def forgot
    @current_user.generate_password_token!
    UserMailer.reset_password_email(@current_user).deliver_later
    render json: {}, status: :ok
  rescue => e
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  def reset
    if login_params[:token].nil? || !@current_user.password_token_valid?
      render json: { errors: [ERROR_MESSAGES[:token_expired]] }, status: :bad_request
      return
    end

    @current_user.reset_password!(login_params[:password])
    render json: {}, status: :ok
  rescue => e
      render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  def logout
    Redis.current.del(@token)
    Rails.logger.info "Account #{@current_account.id} : User #{@current_user.email} has logged out"
    head :no_content
  end

  private
    def login_params
      params.require(:authentication).permit(:email, :password, :password_confirmation, :token)
    end

    def set_user
      @current_user = @current_account.users.find_by_email!(login_params[:email])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: [ERROR_MESSAGES[:invalid_user_email] % login_params[:email]] }, status: :not_found
    end

    def authenticate!
      return unless action_name == 'logout'

      @token = request.headers['Authorization']
      @decoded = JsonWebToken.decode(@token)
      @current_user = @current_account.users.find(@decoded[:user_id]) if @decoded
    rescue => e
      Rails.logger.error "Error while logging out - #{e.message}, account id - #{@current_account.id}, token - #{@token}"
      head :reset_content
    end
end
