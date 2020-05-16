class AuthenticationController < ApplicationController
  include ApplicationConstants
  
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    @user = User.find_by_email(login_params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode({ user_id: @user.id, role: @user.role })
      render json: { token: token, exp: JWT_TOKEN_EXPIRY_TIME }, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

    def login_params
      params.permit(:email, :password)
    end
end
