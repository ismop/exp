# This migration comes from atmosphere (originally 20140209121151)
class AddDefaultToUserFunds < ActiveRecord::Migration
  def change
    change_table :atmosphere_user_funds do |t|
      t.column :default, :boolean, default: false
    end
  end
end
