# This migration comes from atmosphere (originally 20140506124415)
class AddApplianceDescription < ActiveRecord::Migration
  def change
    add_column :atmosphere_appliances, :description, :text

    Atmosphere::Appliance.all.find_each do |appl|
      at = appl.appliance_type
      if at
        appl.name = at.name if appl.name.blank?
        appl.description = at.description if appl.description.blank?
        appl.save!
      end
    end
  end
end
