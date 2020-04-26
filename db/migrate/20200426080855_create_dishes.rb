class CreateDishes < ActiveRecord::Migration[5.2]
  def change
    create_table :dishes do |t|
      t.string :name
      t.text :description
      t.decimal :cost, precision: 15, scale: 2
      t.string :image

      t.timestamps
    end
  end
end
