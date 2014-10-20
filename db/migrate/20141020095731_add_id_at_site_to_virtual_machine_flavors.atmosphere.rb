# This migration comes from atmosphere (originally 20140218085136)
class AddIdAtSiteToVirtualMachineFlavors < ActiveRecord::Migration
  def change
    change_table :atmosphere_virtual_machine_flavors do |t|
      t.column :id_at_site, :string, null: true # Must be true to allow retroactive updates on existing data model
    end
  end
end
