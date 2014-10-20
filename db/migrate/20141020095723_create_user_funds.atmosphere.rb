# This migration comes from atmosphere (originally 20140114111114)
class CreateUserFunds < ActiveRecord::Migration
  def change
    create_table :atmosphere_user_funds do |t|
      t.belongs_to :user
      t.belongs_to :fund
    end
  end
end
