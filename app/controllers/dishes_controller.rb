class DishesController < ApplicationController
  include SwaggerDocs::DishesController

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
    
    def chef_permitted_write_actions
      %i(update)
    end

    def permitted_update_fields
      case @current_user.role.to_sym
      when :admin
        %i(name description cost image is_active)
      when :chef
        %i(is_active)
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    # Only allow a trusted parameter "white list" through.
    def dish_params
      case action_name.to_sym
      when :create
        params.require(:dish).permit(:name, :description, :cost, :image)
      when :update
        params.require(:dish).permit(*permitted_update_fields)
      end
    end
end
