# This migration comes from atmosphere (originally 20140616061353)
class AddActiveToVirtualMachineFlavor < ActiveRecord::Migration
  def change
    add_column :atmosphere_virtual_machine_flavors,
               :active, :boolean, default: true
  end
end
