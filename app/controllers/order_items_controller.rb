class OrderItemsController < ApplicationController
  before_action :validate_user, only: :create
  before_action :set_order

  include ErrorConstants

  # GET /orders/:order_id/order_items/1
  def show
    render json: @order_item
  end

  # POST /orders/:order_id/order_items
  def create
    @order_item = @order.order_items.new(order_item_params)

    if @order_item.save
      render json: @order_item, status: :created, location: @order_item
    else
      render json: @order_item.errors, status: :unprocessable_entity
    end
  end

  # PUT /orders/:order_id/order_items/1
  def update
    if @order_item.update(order_item_params)
      render json: @order_item
    else
      render json: @order_item.errors, status: :unprocessable_entity
    end
  end

  private

    def model
      OrderItem
    end
    
    # Use callbacks to share common setup or constraints between actions.
    # Only allow a trusted parameter "white list" through.
    def order_item_params
      params.permit(:dish_id, :quantity)
    end

    def set_order
      @order = Order.find(params[:order_id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: [ERROR_MESSAGES[:record_not_found] % ['Order', 'id', params[:order_id]]] }, status: :not_found
    end

    def validate_user
      render json: { errors: [ERROR_MESSAGES[:not_privileged]] }, status: :forbidden if @current_user.chef?
    end
end
