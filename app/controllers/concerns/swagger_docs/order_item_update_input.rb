class OrderItemUpdateInput
  include Swagger::Blocks

  swagger_schema :OrderItemUpdateInput do
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
  end
end
