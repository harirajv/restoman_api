class CreateBills < ActiveRecord::Migration[5.2]
  def change
    create_table :bills do |t|
      t.references :order, foreign_key: true
      t.decimal :cost, precision: 15, scale: 2
      t.integer :payment_mode

      t.timestamps
    end
  end
end
