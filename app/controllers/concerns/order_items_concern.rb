module OrderItemsConcern
  def create_order_items(order, order_items_data)
    order_items = order.order_items.build(order_items_data)
    OrderItem.import! order_items, all_or_none: true
  end

  def update_order_items(order, order_items_data)
    # update existing items
    existing_order_items = order.order_items.group_by(&:id)
    order_items_data.each do |order_item_data|
      order_item = existing_order_items[order_item_data[:id].to_i]&.first
      order_item&.update!(order_item_data.except(:id))
    end

    # create new items
    new_order_items = order_items_data.select { |item| existing_order_items[item[:id].to_i].nil? }
    new_order_items.map! { |param| param.as_json.merge({order_id: order.id}) }
    OrderItem.import! new_order_items, all_or_none: true
  end
end
