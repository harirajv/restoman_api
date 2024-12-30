module SwaggerDocs
  class UserSchema
    include Swagger::Blocks

    swagger_schema :UserSchema do
      property :id do
        key :type, :integer
      end
      property :name do
        key :type, :string
      end
      property :email do
        key :type, :string
      end
      property :role do
        key :type, :string
        key :enum, ['admin', 'chef', 'waiter']
      end
      property :created_at do
        key :type, :string
        key :format, :datetime
      end
      property :updated_at do
        key :type, :string
        key :format, :datetime
      end
    end
  end
end