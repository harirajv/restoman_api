class LoginSchema
  include Swagger::Blocks

  swagger_schema :LoginSchema do
    property :id do
      key :type, :integer
    end
    property :role do
      key :type, :string
    end
    property :token do
      key :type, :string
    end
  end
end
