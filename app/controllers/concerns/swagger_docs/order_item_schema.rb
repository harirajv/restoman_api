module SwaggerDocs
  class OrderItemSchema
    include Swagger::Blocks

    swagger_schema :OrderItemSchema do
      property :id do
        key :type, :integer
      end
      property :dish_id do
        key :type, :integer
      end
      property :quantity do
        key :type, :integer
      end
      property :status do
        key :type, :string
        key :enum, ['preparing', 'completed', 'cancelled']
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
