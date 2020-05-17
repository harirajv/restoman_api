class ApplicationController < ActionController::API
  include ApplicationConstants

  before_action :authorize_request

  def authorize_request
    header = request.headers['Authorization'].present? ? request.headers['Authorization'].split(' ').last : nil
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
    
  def index
    @records = paginate model.all, page: page, per_page: per_page
    response.headers['Total-Pages'] = response.headers['Total-Records'].to_i > per_page ?
                                        response.headers['Total-Records'].to_i/per_page : 1
    render json: @records, status: :ok
  end

  def routing_error
    render json: { error: "No route matches #{params[:path]} "}, status: :not_found
  end

  private

    # Model for controller#index
    def model
      raise NoMethodError, 'model method must be overriden'
    end

    # Pagination parameter: page number
    def page
      pagination_params[:page].present? && pagination_params[:page].to_i || PAGINATION_OPTIONS[:page]
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
end
