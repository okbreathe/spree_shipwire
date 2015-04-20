require 'spec_helper'

describe Spree::Order do
  it "checks if ship address has remote errors" do
    order = create(:order_with_line_items)

    expect(order).to be_valid

    order.ship_address.update(remote_validation_error: 'whoops')

    expect(order).to_not be_valid
  end
end
