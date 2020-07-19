class OrderSchema
  include Swagger::Blocks

  swagger_schema :OrderSchema do
    property :id do
      key :type, :integer
    end
    property :table_no do
      key :type, :integer
    end
    property :is_active do
      key :type, :boolean
    end
    property :user_id do
      key :type, :integer
    end
    property :order_items do
      key :type, :array
      items do
        key :'$ref', :OrderItemSchema
      end
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