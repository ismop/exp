# This migration comes from atmosphere (originally 20140325144444)
class ChangeMonitoringStatusDefaultInHttpMapping < ActiveRecord::Migration
  def change
    change_column :atmosphere_http_mappings,
                  :monitoring_status, :string, default: "pending"
  end
end
