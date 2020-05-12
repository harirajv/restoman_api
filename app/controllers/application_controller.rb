class ApplicationController < ActionController::API
  include ApplicationConstants

  before_action :autheniticate_request!, except: :authenticate_user

  attr_reader :current_user
    
  def index
    paginate json: model, page: page, per_page: per_page
  end

  protected

    def autheniticate_request!
      unless user_id_in_token?
        render json: { errors: ['Not Authenticated'] }, status: :unauthorized
        return
      end
      @current_user = User.find(auth_token[:user_id])
    rescue JWT::VerificationError, JWT::DecodeError => e
      render json: { errors: [e.message] }, status: :unauthorized
    end

  private

    # Model for controller#index
    def model
      raise NoMethodError, 'model method must be overriden'
    end

    # Pagination parameter: page number
    def page
      pagination_params[:page].present? && pagination_params[:page].to_i || 
        PAGINATION_OPTIONS[:page]
    end

    # Pagination parameter: number of entries per page
    def per_page
      pagination_params[:per_page].present? ? 
        [pagination_params[:per_page].to_i, PAGINATION_OPTIONS[:max_per_page]].min  : 
        PAGINATION_OPTIONS[:max_per_page]
    end

    # Parameters whitelist for index action
    def pagination_params
      params.permit(:page, :per_page)
    end

    def http_token
      @http_token ||= if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
    end

    def auth_token
      @auth_token ||= JsonWebToken.decode(http_token)
    end

    def user_id_in_token?
      http_token.split('.').size == 3 && auth_token.is_a?(Hash) && auth_token[:user_id].to_i
    end
end
