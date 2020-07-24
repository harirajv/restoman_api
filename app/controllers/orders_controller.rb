class OrdersController < ApplicationController
  before_action :validate_user, only: [:create, :update]

  include ApplicationConstants
  include OrdersConstants
  include OrderItemsConcern
  include Concerns::SwaggerDocs::OrdersController

  # GET /orders
  def index
    orders = paginate Order.includes(:order_items), page: page, per_page: per_page
    render json: orders.to_json(:include => :order_items), status: :ok
  end

  # GET /orders/1
  def show
    render json: @order.to_json(include: :order_items), status: :ok
  end

  # POST /orders
  def create
    ActiveRecord::Base.transaction do
      @order = @current_user.orders.create!(table_no: order_params[:table_no])
      add_order_items(@order, order_items_params)
    end
    render json: @order.to_json(include: :order_items), status: :created
  rescue => e
    Rails.logger.error "Order create failed: #{e.message}, backtrace: #{e.backtrace}"
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  # PUT /orders/1
  def update
    ActiveRecord::Base.transaction do
      @order.update(order_params)
      update_order_items(@order, order_items_params) if params[:order_items]
    end
    render json: @order.to_json(include: :order_items), status: :ok
  rescue => e
    Rails.logger.error "Order update failed: #{e.message}, backtrace: #{e.backtrace}"
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  private
    def model
      Order
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.permit(ORDER_PERMITTED_PARAMS[action_name])
    end

    def order_items_params
      params[:order_items].kind_of?(Array) && params.require(:order_items).map { |param| param.permit(ORDER_ITEM_PERMITTED_PARAMS[action_name]) }
    end

    def validate_user
      unauthorized = case action_name
      when 'create'
        @current_user.chef?
      when 'update'
        params[:order_items] && order_items_params.any? { |data| data[:status].present? && 
                                                                unauthorized_status_update?(@current_user, data[:status]) }
      end

      render json: { errors: [ErrorConstants::ERROR_MESSAGES[:not_privileged]] }, status: :forbidden if unauthorized
    end
end
