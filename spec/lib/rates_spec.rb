require 'spec_helper'

describe SpreeShipwire::Rates do
  it "computes" do
    address    = create(:address, address1: '123 Main', address2: '#101', city: 'Brooklyn', state: create(:state, abbr: 'NY'), zipcode: '12345')
    product1   = create(:product, sku: 'shirt')
    product2   = create(:product, sku: 'bag')
    line_items = [create(:line_item, quantity: 1, variant: product1.master),
                  create(:line_item, quantity: 2, variant: product2.master)]

    rate = double(:rate)
    expect(Shipwire::ShippingRate).to receive(:new)
                                        .with(address: {address1: '123 Main',
                                                        address2:'#101',
                                                        city: 'Brooklyn',
                                                        state: 'NY',
                                                        country: 'US',
                                                        zip: '12345'},
                                              items: [{item: 'shirt', quantity: 1},
                                                      {item: 'bag', quantity: 2}])
                                        .and_return(rate)

    expect(rate).to receive(:send)
    expect(rate).to receive(:parse_response)
    expect(rate).to receive(:shipping_quotes)
                      .and_return(:quotes)

    result = SpreeShipwire::Rates.compute(address, line_items)

    expect(result).to eq(:quotes)
  end
end
