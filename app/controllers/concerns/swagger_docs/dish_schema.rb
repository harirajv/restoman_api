class DishSchema
  include Swagger::Blocks

  swagger_schema :DishSchema do
    property :id do
      key :type, :integer
    end
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
