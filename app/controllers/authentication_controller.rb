class AuthenticationController < ApplicationController
  skip_before_action :authenticate!, on: :login

  include ActionController::ImplicitRender
  include ApplicationConstants
  include ErrorConstants

  # POST /login
  def login
    @user = User.find_by_email(login_params[:email])
    if @user.nil?
      render json: { error: ERROR_MESSAGES[:invalid_user_email] % login_params[:email] }, status: :unauthorized
      return
    end

    if @user.authenticate(login_params[:password])
      @token = JsonWebToken.encode({ user_id: @user.id, role: @user.role })
      render status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

    def model
      # Not relevant
    end

    def login_params
      params.require(:authentication).permit(:email, :password)
    end
end
