module SwaggerDocs
  class OrderItemInput
    include Swagger::Blocks

    swagger_schema :OrderItemInput do
      key :required, [:dish_id, :quantity]
      property :dish_id do
        key :type, :integer
      end
      property :quantity do
        key :type, :integer
      end
    end
  end
end
