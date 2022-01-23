class OrdersController < ApplicationController
  include OrderItemsConcern
  include Concerns::SwaggerDocs::OrdersController

  before_action :validate_status_update, only: :update
  
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
    # TODO Does N+1 insert problem exist here? Is transaction required?
    # Use default has_many association to save records and optimize if necessary
    ActiveRecord::Base.transaction do
      @order = @current_user.orders.create!(table_no: order_params[:table_no])
      add_order_items(@order, order_items_params)
    end
    render json: @order.to_json(include: :order_items), status: :created
  rescue => e
    Rails.logger.error "Order create failed: #{e.message}, backtrace: #{e.backtrace}"
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  # PUT /orders/1
  def update
    ActiveRecord::Base.transaction do
      @order.update(order_params)
      update_order_items(@order, order_items_params) if order_items_params.present?
    end
    render json: @order.to_json(include: :order_items), status: :ok
  rescue => e
    Rails.logger.error "Order update failed: #{e.message}, backtrace: #{e.backtrace}"
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  private
    def model
      Order
    end

    def write_actions
      %i(create update)
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      case action_name.to_sym
      when :create
        params.require(:order).permit(:table_no, :order_items)
      when :update
        params.require(:order).permit(:table_no, :is_active, :order_items)
      end
    end

    def order_items_params
      case action_name.to_sym
      when :create
        params.require(:order_items).map { |order_item| order_item.permit(:dish_id, :quantity) }
      when :update
        params.require(:order_items).map { |order_item| order_item.permit(:id, :dish_id, :quantity, :status) }
      end
    end

    def chef_permitted_write_actions
      %i(update)
    end

    def waiter_permitted_write_actions
      %i(create update)
    end

    def permitted_status_update?(status)
      case @current_user.role.to_sym
      when :admin
        true
      when :chef
        status == 'completed'
      when :waiter
        status != 'completed'
      end
    end

    def validate_status_update
      invalid_order_items = order_items_params.select { |item_params| item_params.has_key?(:status) && !permitted_status_update?(item_params[:status]) }
      return if invalid_order_items.empty?

      error_messages = invalid_order_items.map { |item_params| ERROR_MESSAGES[:update_not_allowed] % "status #{item_params[:status]} in item ##{item_params[:id]}" }
      render json: { errors: error_messages }, status: :forbidden and return
    end
end
