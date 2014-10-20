# This migration comes from atmosphere (originally 20140317193550)
class MonitoringStatusDefaultToHttpMapping < ActiveRecord::Migration
  def change
    change_column :atmosphere_http_mappings,
                  :monitoring_status, :string, default: "new"
  end
end
