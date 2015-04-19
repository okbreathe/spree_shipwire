class AddFieldsToSpreeShippingRates < ActiveRecord::Migration
  def change
    add_column :spree_shipping_rates, :name, :string
    add_column :spree_shipping_rates, :carrier_code, :string
  end
end
