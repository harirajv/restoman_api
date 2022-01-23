module SwaggerDocs
  module UsersController
    extend ActiveSupport::Concern

    included do
      include Swagger::Blocks

      swagger_path '/users' do
        operation :get do
          key :summary, 'List of Users'
          key :operationId, 'getUsers'
          key :tags, ['user']

          response 200 do
            key :description, 'Users list'
            schema do
              key :type, :array
              items do
                key:'$ref', :UserSchema
              end
            end
          end
        end

        operation :post do
          key :summary, 'Create a User'
          key :operationId, 'createUser'
          key :tags, ['user']

          parameter do
            key :name, :body
            key :in, :body
            key :description, 'User data to be created'
            key :required, true
            schema do
              key :'$ref', :UserInput
            end
          end

          response 201 do
            key :description, 'User created'
            schema do
              key :'$ref', :UserSchema
            end
          end
          response 403 do
            key :description, "Insufficient privileges\nAdmin role required"
          end
          response 422 do
            key :description, 'Invalid parameters'
          end
        end
      end

      swagger_path '/users/{id}' do
        operation :get do
          key :summary, 'Find a User by id'
          key :operationId, 'findUserById'
          key :tags, ['user']

          parameter do
            key :name, :id
            key :in, :path
            key :description, 'Id of User to find'
            key :required, true
            key :type, :integer
          end

          response 200 do
            key :description, 'User found'
            schema do
              key :'$ref', :UserSchema
            end
          end
          response 404 do
            key :description, 'User not found for given id'
          end
        end

        operation :put do
          key :summary, 'Update a User by id'
          key :operationId, 'updateUser'
          key :tags, ['user']

          parameter do
            key :name, :id
            key :in, :path
            key :description, 'Id of User to update'
            key :required, true
            key :type, :integer
          end
          parameter do
            key :name, :body
            key :in, :body
            key :description, 'User data to be updated'
            key :required, true
            schema do
              key :'$ref', :UserInput
            end
          end

          response 200 do
            key :description, 'User updated'
            schema do
              key :'$ref', :UserSchema
            end
          end
          response 403 do
            key :description, "Insufficient privileges\nChef and Waiter cannot update role"
          end
          response 404 do
            key :description, 'User not found for given id'
          end
          response 422 do
            key :description, 'Invalid parameters'
          end
        end
      end
    end
  end
end
