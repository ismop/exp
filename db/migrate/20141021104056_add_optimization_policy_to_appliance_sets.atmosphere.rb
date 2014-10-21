# This migration comes from atmosphere (originally 20140913184638)
class AddOptimizationPolicyToApplianceSets < ActiveRecord::Migration
  def change
    add_column :atmosphere_appliance_sets, :optimization_policy, :string
  end
end
