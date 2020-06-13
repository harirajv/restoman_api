class DishesController < ApplicationController
  # before_action :set_dish, only: [:show, :update, :destroy]
  before_action :validate_user, only: [:create, :update, :destroy]

  include ApplicationConstants
  include DishesConstants
  include ErrorConstants

  # GET /dishes/1
  def show
    render json: @dish
  end

  # POST /dishes
  def create
    @dish = Dish.new(dish_params)

    if @dish.save
      render json: @dish, status: :created, location: @dish
    else
      render json: @dish.errors, status: :unprocessable_entity
    end
  end

  # PUT /dishes/1
  def update
    unallowed_fields = dish_params.keys - UPDATE_ALLOWED_FIELDS[@current_user.role]
    if unallowed_fields.present?
      render json: { errors: [ERROR_MESSAGES[:UPDATE_NOT_ALLOWED] % unallowed_fields.join(', ')] }, status: :forbidden
      return
    end
    
    if @dish.update(dish_params)
      render json: @dish
    else
      render json: @dish.errors, status: :unprocessable_entity
    end
  end

  # DELETE /dishes/1
  def destroy
    @dish.destroy
  end

  private

    def model
      Dish
    end

    # Use callbacks to share common setup or constraints between actions.
    # Only allow a trusted parameter "white list" through.
    def dish_params
      params.permit(:name, :description, :cost, :image)
    end    

    def validate_user
      render json: { errors: [ERROR_MESSAGES[:not_privileged]] },
             status: :forbidden if RESTRICTED_ACTIONS[@current_user.role].include?(action_name)
    end
end
