class AddIsActiveToDish < ActiveRecord::Migration[5.2]
  def change
    add_column :dishes, :is_active, :boolean, default: true
  end
end
