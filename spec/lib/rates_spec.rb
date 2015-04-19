require 'spec_helper'

describe SpreeShipwire::Rates do
  let(:address)    { create(:address, address1: '123 Main', address2: '#101', city: 'Brooklyn', state: create(:state, abbr: 'NY'), zipcode: '12345') }
  let(:product1)   { create(:product, sku: 'shirt') }
  let(:product2)   { create(:product, sku: 'bag') }
  let(:line_items) { [create(:line_item, quantity: 1, variant: product1.master),
                      create(:line_item, quantity: 2, variant: product2.master)] }
  let(:rate)       { double(:rate) }

  context "computing rate" do
    it "returns quotes" do
      expect(Shipwire::ShippingRate).to receive(:new)
                                          .with(address: {address1: '123 Main',
                                                          address2:'#101',
                                                          city: 'Brooklyn',
                                                          state: 'NY',
                                                          country: 'US',
                                                          zip: '12345'},
                                                items: [{code: 'shirt', quantity: 1},
                                                        {code: 'bag', quantity: 2}])
                                          .and_return(rate)

      response = Faraday::Response.new(body: '<Warning></Warning>')

      expect(rate).to receive(:send).and_return(response)
      expect(rate).to receive(:parse_response)
      expect(rate).to receive(:shipping_quotes)
                        .and_return(:quotes)

      result = SpreeShipwire::Rates.compute(address, line_items)

      expect(result).to eq(:quotes)
    end

    it "raises when unable to connect" do
      expect(Shipwire::ShippingRate).to receive(:new).and_return(rate)

      expect(rate).to receive(:send).and_return(['Unable to connect to Shipwire'])

      expect{SpreeShipwire::Rates.compute(address, line_items)}.to raise_error(SpreeShipwire::ConnectionError)
    end

    it "raises when unable to get shipping rates" do
      expect(Shipwire::ShippingRate).to receive(:new).and_return(rate)

      expect(rate).to receive(:send).and_return(['Unable to get shipping rates from Shipwire'])

      expect{SpreeShipwire::Rates.compute(address, line_items)}.to raise_error(SpreeShipwire::RateError)
    end

    it "raises when address is invalid" do
      response = Faraday::Response.new(body: '<Warning>Could not verify shipping address</Warning>')

      expect(Shipwire::ShippingRate).to receive(:new)
                                          .with(address: {address1: '123 Main',
                                                          address2:'#101',
                                                          city: 'Brooklyn',
                                                          state: 'NY',
                                                          country: 'US',
                                                          zip: '12345'},
                                                items: [{code: 'shirt', quantity: 1},
                                                        {code: 'bag', quantity: 2}])
                                          .and_return(rate)

      expect(rate).to receive(:send).and_return(response)
      expect{SpreeShipwire::Rates.compute(address, line_items)}.to raise_error(SpreeShipwire::AddressError)
    end

    it "raises when sku not found" do
      response = Faraday::Response.new(body: '<Warning>Unrecognized SKU (item 1)</Warning>')

      expect(Shipwire::ShippingRate).to receive(:new).and_return(rate)

      expect(rate).to receive(:send).and_return(response)

      expect{SpreeShipwire::Rates.compute(address, line_items)}.to raise_error(SpreeShipwire::UnrecognizedSKUError)
    end
  end
end
