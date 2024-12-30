module SwaggerDocs
  class OrderUpdateInput
    include Swagger::Blocks

    swagger_schema :OrderUpdateInput do
      key :required, [:table_no]
      property :table_no do
        key :type, :integer
      end
      property :order_items do
        key :type, :array
        items do
          key :'$ref', :OrderItemUpdateInput
        end
      end
    end
  end
end
