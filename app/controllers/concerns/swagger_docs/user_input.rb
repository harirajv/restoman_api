class UserInput
  include Swagger::Blocks

  swagger_schema :UserInput do
    key :required, [:name, :email, :role]
    property :name do
      key :type, :string
    end
    property :email do
      key :type, :string
    end
    property :password do
      key :type, :string
    end
    property :password_confirmation do
      key :type, :string
    end
    property :role do
      key :type, :integer
    end
  end
end
