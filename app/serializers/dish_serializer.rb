class DishSerializer < ActiveModel::Serializer
  attributes :id, :name,:description, :cost, :image, :created_at, :updated_at, :is_active
end
