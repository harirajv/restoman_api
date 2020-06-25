class ApplicationController < ActionController::API
  before_action :authenticate!, except: :routing_error
  before_action :set_record, only: [:show, :update, :destroy]
  before_action :set_response_headers, only: :index

  include ApplicationConstants
    
  def index
    @records = paginate model, page: page, per_page: per_page
    # response.headers['Total-Pages'] = total_pages
    render json: @records, status: :ok
  end

  def routing_error
    render json: { error: "No route matches #{request.method} #{params[:path]} "}, status: :not_found
  end

  private
  
    # Model for controller#index
    def model
      raise NoMethodError, 'model method must be overriden'
    end

    def set_record
      instance_variable_set("@#{model.to_s.underscore}", model.find(params[:id]))
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: [ErrorConstants::ERROR_MESSAGES[:record_not_found] % [model, 'id', params[:id]]] }, status: :not_found
    end

    def authenticate!
      return @current_user if @current_user.present?

      header = request.headers['Authorization'].present? ? request.headers['Authorization'].split(' ').last : nil
      begin
        @decoded = JsonWebToken.decode(header)
        @current_user = User.find(@decoded[:user_id])
      rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
        render json: { errors: [e.message] }, status: :unauthorized
      end
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

    def total_pages
      response.headers['Total-Records'].to_i > per_page ? response.headers['Total-Records'].to_i/per_page : 1
    end

    # Parameters whitelist for index action
    def pagination_params
      params.permit(:page, :per_page)
    end

    def set_response_headers
      response.set_header('Total-Pages', total_pages)
    end
end
