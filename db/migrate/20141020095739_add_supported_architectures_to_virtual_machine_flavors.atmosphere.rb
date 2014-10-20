# This migration comes from atmosphere (originally 20140325115017)
class AddSupportedArchitecturesToVirtualMachineFlavors < ActiveRecord::Migration
  def change
    add_column :atmosphere_virtual_machine_flavors,
               :supported_architectures, :string, default: 'x86_64'
  end
end
