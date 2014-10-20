# This migration comes from atmosphere (originally 20140127082332)
class AddStateExplanationToAppliance < ActiveRecord::Migration
  def change
    change_table :atmosphere_appliances do |t|
      t.column :state_explanation, :string, null: true
    end
  end
end
