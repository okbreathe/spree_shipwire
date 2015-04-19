require 'spec_helper'

describe Spree::ShippingRate do
  it "uses name from db" do
    rate = Spree::ShippingRate.create(name: 'FedEx SuperSaver')

    expect(rate.name).to eq('FedEx SuperSaver')
  end
end
