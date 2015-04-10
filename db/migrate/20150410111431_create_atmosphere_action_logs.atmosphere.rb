# This migration comes from atmosphere (originally 20150112083118)
class CreateAtmosphereActionLogs < ActiveRecord::Migration
  def change
    create_table :atmosphere_action_logs do |t|
      t.string :message
      t.string :log_level
      t.references :action, index: true
      t.timestamps
    end
  end
end
