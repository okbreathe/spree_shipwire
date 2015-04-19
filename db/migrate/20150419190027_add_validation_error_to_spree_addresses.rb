class AddValidationErrorToSpreeAddresses < ActiveRecord::Migration
  def change
    add_column :spree_addresses, :remote_validation_error, :string
  end
end
