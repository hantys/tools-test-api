class AddAuthTokenToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :auth_token, :string, unique:  true
    add_index :users, :auth_token, unique:  true
  end
end
