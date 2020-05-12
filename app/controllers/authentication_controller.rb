class AuthenticationController < ApplicationController
  def authenticate_user
    user = User.find_for_database_authentication(email: auth_params[:email])
    if user.valid_password?(auth_params[:password])
      render json: payload(user)
    else
      render json: { errors: ['Invalid username/password'] }, status: :unathorized
    end
  end

  private

    def payload(user)
      return nil unless user && user.id
      {
        auth_token: JsonWebToken.encode({ user_id: user.id }),
        user: { id: user.id, email: user.email }
      }
    end

    def auth_params
      params.permit(:email, :password)
    end
end