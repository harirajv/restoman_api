class ApplicationController < ActionController::API
  before_action :authenticate!, except: :routing_error
  before_action :set_record, only: [:show, :update, :destroy]
  before_action :set_response_headers, only: :index
  before_action :validate_user, if: -> { write_actions.include?(action_name.to_sym) }

  include ApplicationConstants
  include ErrorConstants

  rescue_from ActionController::ParameterMissing do |exception|
    render json: { errors: [ERROR_MESSAGES[:missing_params]] }, status: :bad_request
  end
  
  rescue_from ActionController::UnpermittedParameters do |exception|
    render json: { errors: [ERROR_MESSAGES[:invalid_params] % exception.params.join(', ')] }, status: :bad_request
  end
    
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
      @token = request.headers['Authorization']
      @decoded = JsonWebToken.decode(@token)
      render json: { errors: [ErrorConstants::ERROR_MESSAGES[:logged_out]] }, status: :unauthorized and return unless Redis.current.get(@token)

      @current_user = User.find(@decoded[:user_id])
      Redis.current.expire(@token, JWT_EXPIRY_TIME)
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
      render json: { errors: [e.message] }, status: :unauthorized
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
      return {} unless params.has_key?(:page) || params.has_key?(:per_page)

      params.require(controller_name.singularize.to_sym).permit(:page, :per_page)
    end

    def set_response_headers
      response.set_header('Total-Pages', total_pages)
    end

    def write_actions
      %i(create update destroy)
    end

    def admin_permitted_write_actions
      write_actions
    end

    def chef_permitted_write_actions
      []
    end

    def waiter_permitted_write_actions
      []
    end

    def permitted_write?
      permitted_actions = send "#{@current_user.role}_permitted_write_actions"
      permitted_actions.include? action_name.to_sym
    end

    def validate_user
      render json: { errors: [ERROR_MESSAGES[:not_privileged]] }, status: :forbidden unless permitted_write?
    end
end
