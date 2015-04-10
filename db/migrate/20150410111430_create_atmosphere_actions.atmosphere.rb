# This migration comes from atmosphere (originally 20150112083059)
class CreateAtmosphereActions < ActiveRecord::Migration
  def change
    create_table :atmosphere_actions do |t|
      t.string :action_type
      t.references :appliance, index: true
      t.datetime :created_at
    end
  end
end
