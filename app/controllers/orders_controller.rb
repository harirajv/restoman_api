class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update]
  before_action :validate_user, only: [:create, :update]

  include ApplicationConstants

  # GET /orders/1
  def show
    render json: @order
  end

  # POST /orders
  def create
    @order = @current_user.orders.new(order_params)

    if @order.save
      render json: @order, status: :created, location: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PUT /orders/1
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
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
      params.permit(:table_no, :is_active)
    end

    def validate_user
      render json: { errors: [ErrorConstants::ERROR_MESSAGES[:not_privileged]] }, status: :forbidden if @current_user.chef?
    end
end
