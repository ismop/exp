# This migration comes from atmosphere (originally 20140430115142)
class ChangeZabbixHostIdToMonitoringIdInVirtualMachines < ActiveRecord::Migration

  def up
    change_table :atmosphere_virtual_machines do |t|
      t.rename :zabbix_host_id, :monitoring_id
    end
  end

  def down
    change_table :atmosphere_virtual_machines do |t|
      t.rename :monitoring_id, :zabbix_host_id
    end
  end
end
