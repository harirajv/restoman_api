module OrderItemsConcern
  def create_order_items(order, order_items_data)
    order_items = order.order_items.build(order_items_data)
    OrderItem.import! order_items, all_or_none: true
  end

  def update_order_items(order, order_items_data)
    final_items = []

    # update existing items
    existing_order_items = order.order_items.group_by(&:id)
    order_items_data.each do |order_item_data|
      item = existing_order_items[order_item_data[:id]]
      final_items << item.assign_attributes(order_item_data.except(:id)) if item
    end

    # create new items
    new_order_items = order_items_data.select { |item| existing_order_items[item[:id].to_i].nil? }
    final_items += order.order_items.new(new_order_items) if new_order_items

    OrderItem.import! final_items, all_or_none: true
  end
end
