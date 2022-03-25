class CreateAccountsAndAddAccountIdReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.string :subdomain, null: false, index: { unique: true }

      t.timestamps
    end

    %w(dishes orders users).each do |table|
      add_reference table, :account, foreign_key: true
    end
  end
end
