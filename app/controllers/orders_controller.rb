class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update]
  before_action :validate_user, only: [:create, :update]

  include ActionController::ImplicitRender
  include ApplicationConstants
  include OrderItemsConcern
  include Concerns::SwaggerDocs::OrdersController

  # GET /orders/1
  def show
    render json: @order
  end

  # POST /orders
  def create
    ActiveRecord::Base.transaction do
      @order = @current_user.orders.create!(table_no: order_params[:table_no])
      add_order_items(@order, order_items_params)
    end
    @order_items = @order.order_items.reload
    render status: :created
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
    @order_items = @order.order_items.reload
  rescue => e
    Rails.logger.error "Order update failed: #{e.message}, backtrace: #{e.backtrace}"
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  private
    def model
      Order
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      case action_name.to_sym
      when :create
        params.permit(:table_no)
      when :update
        params.permit(:table_no, :is_active)
      end
    end

    def order_items_params
      case action_name.to_sym
      when :create
        params.require(:order_items).map { |param| param.permit(:dish_id, :quantity) }
      when :update
        # TODO order items status update
        params.require(:order_items).map { |param| param.permit(:id, :dish_id, :quantity) }
      end
    end

    def validate_user
      # TODO chef must be able to update order items status
      render json: { errors: [ErrorConstants::ERROR_MESSAGES[:not_privileged]] }, status: :forbidden if @current_user.chef?
    end
end
