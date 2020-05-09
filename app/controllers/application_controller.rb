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
      params[:page].present? && params[:page].to_i || PAGINATION_OPTIONS[:page]
    end

    # Pagination parameter: number of entries per page
    def per_page
      params[:per_page].present? ? [params[:per_page].to_i, PAGINATION_OPTIONS[:max_per_page]].min
                                 : PAGINATION_OPTIONS[:max_per_page]
    end
end
