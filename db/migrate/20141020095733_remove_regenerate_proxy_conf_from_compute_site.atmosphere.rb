# This migration comes from atmosphere (originally 20140310073458)
class RemoveRegenerateProxyConfFromComputeSite < ActiveRecord::Migration
  def change
    remove_column :atmosphere_compute_sites, :regenerate_proxy_conf, :boolean
  end
end
