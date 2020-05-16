class AddEmailAndPasswordDigestToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :email, :string
    add_column :users, :password_digest, :string

    add_index :users, :email
  end
end
