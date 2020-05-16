class ApplicationController < ActionController::API
  include ApplicationConstants
    
  def index
    paginate json: model, page: page, per_page: per_page
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
end
