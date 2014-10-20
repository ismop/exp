# This migration comes from atmosphere (originally 20140204132451)
class NullifyAtVmtFk < ActiveRecord::Migration
  def change
    remove_foreign_key :atmosphere_virtual_machine_templates,
                       name: 'atmo_vmt_at_fk'

    add_foreign_key :atmosphere_virtual_machine_templates,
                    :atmosphere_appliance_types,
                    column: 'appliance_type_id',
                    dependent: :nullify
  end
end
