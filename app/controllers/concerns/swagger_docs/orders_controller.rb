module SwaggerDocs
  module OrdersController
    extend ActiveSupport::Concern

    included do
      include Swagger::Blocks

      swagger_path '/orders' do
        operation :get do
          key :summary, 'List of Orders created by User'
          key :operationId, 'getOrders'
          key :tags, ['order']

          response 200 do
            key :description, 'Orders created by current User'
            schema do
              key :type, :array
              items do
                key:'$ref', :OrderSchema
              end
            end
          end
        end

        operation :post do
          key :summary, 'Create an Order'
          key :operationId, 'createOrder'
          key :tags, ['order']

          parameter do
            key :name, :body
            key :in, :body
            key :description, 'Order data to be created'
            key :required, true
            schema do
              key :'$ref', :OrderInput
            end
          end

          response 201 do
            key :description, 'Order created'
            schema do
              key '$ref', :OrderSchema
            end
          end
          response 403 do
            key :description, "Insufficient privileges\nChef cannot create order"
          end
          response 422 do
            key :description, 'Invalid parameters'
          end
        end
      end

      swagger_path '/orders/{id}' do
        operation :get do
          key :summary, 'Find an Order by id'
          key :operationId, 'findOrderById'
          key :tags, ['order']

          parameter do
            key :name, :id
            key :in, :path
            key :description, 'Id of Order to find'
            key :required, true
          end

          response 200 do
            key :description, 'Order found'
            schema do
              key '$ref', :OrderSchema
            end
          end
          response 404 do
            key :description, 'Order not found for given id'
          end
        end

        operation :put do
          key :summary, 'Update an Order by id'
          key :operationId, 'updateOrderById'
          key :tags, ['order']

          parameter do
            key :name, :id
            key :in, :path
            key :description, 'Id of Order to update'
            key :required, true
          end
          parameter do
            key :name, :body
            key :in, :body
            key :description, 'Order data to be updated'
            key :required, true
            schema do
              key :'$ref', :OrderUpdateInput
            end
          end

          response 200 do
            key :description, 'Order updated'
            schema do
              key '$ref', :OrderSchema
            end
          end
          response 403 do
            key :description, "Insufficient privileges\nChef can update only order items"
          end
          response 404 do
            key :description, 'Order not found for given id'
          end
          response 422 do
            key :description, 'Invalid parameters'
          end
        end
      end
    end
  end
end
