module OrderItemsConcern
  def add_order_items(order, order_items_data)
    order_items = order_items_data.map { |item| item.to_h.merge(order_id: order.id) }
    OrderItem.import! order_items, all_or_none: true
  end

  def modify_order_items(order, order_items_data)
    order_items_data.each do |data|
      order_item = order.order_items.where(id: data[:id]).first
      order_item.update!(data.except(:id))
    end
  end

  def update_order_items(order, order_items_data)
    new_items, existing_items = order_items_data.partition { |item| item[:id].nil? }
    add_order_items(order, new_items)
    modify_order_items(order, existing_items)
  end

  def unauthorized_status_update?(user, status)
    # Chef can only set OrderItem status to completed
    # Waiter cannot set OrderItem status to completed
    return true if (user.chef? && status != 'completed') ||
                    (user.waiter? && status == 'completed')
    false
  end
end
