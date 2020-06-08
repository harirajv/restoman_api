class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :table_no
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
