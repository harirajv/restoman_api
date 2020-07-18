module Concerns
  module SwaggerDocs
    module UsersController
      extend ActiveSupport::Concern

      included do
        include Swagger::Blocks

        swagger_path '/users' do
          operation :get do
            key :summary, 'List Users'
            key :description, 'Returns list of users if the user has access'
            key :operationId, 'getUsers'
            key :tags, ['user']

            response 200 do
              key :description, 'Users response'
              schema do
                key :type, :array
                items do
                  key :'$ref', :UserSchema
                end
              end
            end
          end

          operation :post do
            key :summary, 'Create User'
            key :description, 'Creates a user'
            key :operationId, 'createUsers'
            key :tags, ['user']

            parameter do
              key :name, :body
              key :in, :body
              key :description, 'User data to be added'
              key :required, true
              schema do
                key :'$ref', :UserInput
              end
            end

            response 201 do
              schema do
                key :'$ref', :UserSchema
              end
            end

            response 422 do
              key :description, 'Invalid parameters'
            end
          end
        end

        swagger_path '/users/{id}' do
          operation :get do
            key :summary, 'Find User by ID'
            key :description, 'Returns a single user if the user has access'
            key :operationId, 'findUserById'
            key :tags, ['user']

            parameter do
              key :name, :id
              key :in, :path
              key :description, 'ID of user to fetch'
              key :required, true
              key :type, :integer
            end

            response 200 do
              key :description, 'User response'
              schema do
                key :'$ref', :UserSchema
              end
            end

            response 404 do
              key :description, 'User not found for given id'
            end
          end

          operation :put do
            key :summary, 'Update an existing user'
            key :description, 'User data that needs to be updated'
            key :operationId, 'updateUser'
            key :tags, ['user']

            parameter do
              key :name, :body
              key :in, :body
              key :description, 'User data to be added'
              key :required, true
              schema do
                key :'$ref', :UserInput
              end
            end

            response 200 do
              key :description, 'User response'
              schema do
                key :'$ref', :UserSchema
              end
            end

            response 404 do
              key :description, 'User not found for given id'
            end
          end
        end
      end
    end
  end
end
