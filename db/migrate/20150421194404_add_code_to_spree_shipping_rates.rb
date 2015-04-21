class AddCodeToSpreeShippingRates < ActiveRecord::Migration
  def change
    add_column :spree_shipping_rates, :code, :string
  end
end
