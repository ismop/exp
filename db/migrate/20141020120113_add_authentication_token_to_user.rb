class AddAuthenticationTokenToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :atmosphere_users, :authentication_token, :string
    add_index :atmosphere_users, :authentication_token, unique: true
  end
end
