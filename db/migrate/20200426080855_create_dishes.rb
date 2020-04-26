class CreateDishes < ActiveRecord::Migration[5.2]
  def change
    create_table :dishes do |t|
      t.string :name
      t.text :description
      t.numeric :cost
      t.string :image

      t.timestamps
    end
  end
end
