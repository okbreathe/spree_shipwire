class AddShipwireFields < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_addresses, :remote_validation_error, :string
    add_column :spree_shipping_rates, :name, :string
    add_column :spree_shipping_rates, :carrier_code, :string
    add_column :spree_shipping_rates, :code, :string
  end
end
