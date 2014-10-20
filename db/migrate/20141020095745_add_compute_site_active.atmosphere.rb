# This migration comes from atmosphere (originally 20140602070848)
class AddComputeSiteActive < ActiveRecord::Migration
  def change
    add_column :atmosphere_compute_sites, :active, :boolean, default: true
  end
end
