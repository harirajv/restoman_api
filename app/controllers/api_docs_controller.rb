class ApiDocsController < ActionController::Base
  include Swagger::Blocks

  swagger_root  do
    key :swagger, '2.0'
    info do
      key :version, '1.0'
      key :title, 'Restoman API'
      license do
        key :name, 'MIT'
        key :url, 'https://opensource.org/licenses/MIT'
      end
    end
    tag do
      key :name, 'user'
      key :description, 'User management'
    end
    
    key :host, 'http://localhost:3000'
    key :basePath, '/api'
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    UsersController,
    UserSchema,
    UserInput,
    self,
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
