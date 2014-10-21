# This migration comes from atmosphere (originally 20140918140228)
class AddOptimizationPolicyToAppliances < ActiveRecord::Migration
  def change
    add_column :atmosphere_appliances, :optimization_policy, :string
  end
end
