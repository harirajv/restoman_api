module SwaggerDocs
  class OrderInput
    include Swagger::Blocks

    swagger_schema :OrderInput do
      key :required, [:table_no]
      property :table_no do
        key :type, :integer
      end
      property :order_items do
        key :type, :array
        items do
          key :'$ref', :OrderItemInput
        end
      end
    end
  end
end
