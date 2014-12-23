# This migration comes from atmosphere (originally 20141202081811)
class AddVersionToVmt < ActiveRecord::Migration
  def up
    add_column :atmosphere_virtual_machine_templates, :version, :integer

    Atmosphere::VirtualMachineTemplate.find_each do |vmt|
      vmt.version = 1
      vmt.save
    end
  end

  def down
    remove_column :atmosphere_virtual_machine_templates, :version, :integer
  end
end
