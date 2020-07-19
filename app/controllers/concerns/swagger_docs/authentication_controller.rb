module Concerns
  module SwaggerDocs
    module AuthenticationController
      extend ActiveSupport::Concern

      included do
        include Swagger::Blocks

        swagger_path '/users/login' do
          operation :post do
            key :summary, 'Login with User credentials'
            key :operationId, 'login'
            key :tags, ['auth']

            parameter do
              key :name, :email
              key :in, :query
              key :description, "User email"
              key :required, true
              key :type, :string
            end
            parameter do
              key :name, :password
              key :in, :query
              key :description, "User password"
              key :required, true
              key :type, :string
            end

            response 200 do
              key :description, 'Login successful'
              schema do
                key :'$ref', :LoginSchema
              end
            end

            response 401 do
              key :description, 'Password is invalid'
            end

            response 404 do
              key :description, "User with given email doesn't exist"
            end
          end
        end

        swagger_path '/users/forgot' do
          operation :post do
            key :summary, 'Forgot password'
            key :operationId, 'forgotPassword'
            key :tags, ['auth']

            parameter do
              key :name, :email
              key :in, :query
              key :description, "Email"
              key :required, true
              key :type, :string
            end

            response 200 do
              key :description, 'Forgot password email initiated'
            end

            response 404 do
              key :description, "User with given email doesn't exist."
            end
          end
        end

        swagger_path '/users/reset' do
          operation :put do
            key :summary, 'Reset password for User'
            key :operationId, 'resetPassword'
            key :tags, ['auth']

            parameter do
              key :name, :email
              key :in, :query
              key :description, "User email"
              key :required, true
              key :type, :string
            end
            parameter do
              key :name, :password
              key :in, :query
              key :description, "User password"
              key :required, true
              key :type, :string
            end
            parameter do
              key :name, :token
              key :in, :query
              key :description, "Password reset token from forgot password email"
              key :required, true
              key :type, :string
            end

            response 200 do
              key :description, 'Password reset completed'
            end

            response 400 do
              key :description, 'Invalid password reset token'
            end

            response 404 do
              key :description, "User with given email doesn't exist"
            end
          end
        end
      end
    end
  end
end
