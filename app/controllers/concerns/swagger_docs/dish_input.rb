class DishInput
  include Swagger::Blocks

  swagger_schema :DishInput do
    key :required, [:name, :description, :cost]
    property :name do
      key :type, :string
    end
    property :description do
      key :type, :string
    end
    property :cost do
      key :type, :number
      key :format, :double
    end
    property :image do
      key :type, :string
    end
  end
end
