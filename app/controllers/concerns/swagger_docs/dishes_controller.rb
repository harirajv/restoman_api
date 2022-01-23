module SwaggerDocs
  module DishesController
    extend ActiveSupport::Concern

    included do
      include Swagger::Blocks

      swagger_path '/dishes' do
        operation :get do
          key :summary, 'List of Dishes'
          key :operationId, 'getDishes'
          key :tags, ['dish']

          response 200 do
            key :description, 'Dishes list'
            schema do
              key :type, :array
              items do
                key:'$ref', :DishSchema
              end
            end
          end
        end

        operation :post do
          key :summary, 'Create a Dish'
          key :operationId, 'createDish'
          key :tags, ['dish']

          parameter do
            key :name, :body
            key :in, :body
            key :description, 'Dish data to be created'
            key :required, true
            schema do
              key :'$ref', :DishInput
            end
          end

          response 201 do
            key :description, 'Dish created'
            schema do
              key :'$ref', :DishSchema
            end
          end
          response 422 do
            key :description, 'Invalid parameters'
          end
        end
      end

      swagger_path '/dishes/{id}' do
        operation :get do
          key :summary, 'Find a Dish by id'
          key :operationId, 'findDishById'
          key :tags, ['dish']

          parameter do
            key :name, :id
            key :in, :path
            key :description, 'Id of Dish to find'
            key :required, true
            key :type, :integer
          end

          response 200 do
            key :description, 'Dish found'
            schema do
              key :'$ref', :DishSchema
            end
          end
          response 404 do
            key :description, 'Dish not found for given id'
          end
        end

        operation :put do
          key :summary, 'Update a Dish by id'
          key :operationId, 'updateDishById'
          key :tags, ['dish']

          parameter do
            key :name, :id
            key :in, :path
            key :description, 'Id of Dish to update'
            key :required, true
            key :type, :integer
          end
          parameter do
            key :name, :body
            key :in, :body
            key :description, 'Dish data to be updated'
            key :required, true
            schema do
              key :'$ref', :DishInput
            end
          end

          response 200 do
            key :description, 'Dish updated'
            schema do
              key :'$ref', :DishSchema
            end
          end
          response 404 do
            key :description, 'Dish not found for given id'
          end
          response 422 do
            key :description, 'Invalid parameters'
          end
        end

        operation :delete do
          key :summary, 'Delete a Dish by id'
          key :operationId, 'deleteDishById'
          key :tags, ['dish']

          parameter do
            key :name, :id
            key :in, :path
            key :description, 'Id of dish to delete'
            key :required, true
            key :type, :integer
          end

          response 204 do
            key :description, 'Dish deleted'
          end
          response 404 do
            key :description, 'Dish not found for given id'
          end
        end
      end
    end
  end
end
