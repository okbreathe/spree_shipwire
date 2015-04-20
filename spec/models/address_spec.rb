require 'spec_helper'

describe Spree::Address do
  it "clears remote error when address changed" do
    address = create(:address)

    expect(address.remote_validation_error).to be_nil

    address.update(remote_validation_error: 'oops')

    expect(address.remote_validation_error).to eq('oops')

    address.address1 = '123 Main St.'
    address.save

    expect(address.remote_validation_error).to be_nil
  end
end
