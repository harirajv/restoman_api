module OrdersConstants
  ORDER_PERMITTED_PARAMS = {
    create: %i(table_no),
    update: %i(table_no is_active)
  }.with_indifferent_access.freeze

  ORDER_ITEM_PERMITTED_PARAMS = {
    create: %i(dish_id quantity),
    update: %i(id dish_id quantity)
  }.with_indifferent_access.freeze
end.freeze
