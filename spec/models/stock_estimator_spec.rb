require 'spec_helper'

describe Spree::Stock::Estimator do
  context "complete order" do
    it "uses existing rates" do
      order = create(:completed_order_with_totals)
      estimator = Spree::Stock::Estimator.new(order)

      shipment = order.shipments.first
      package = shipment.to_package

      expect(SpreeShipwire::Rates).to_not receive(:compute)

      rates = estimator.shipping_rates(package)

      expect(rates.count).to eq(1)
    end
  end

  context "incomplete order" do
    let!(:order) { create(:order_with_line_items) }
    let(:estimator) { Spree::Stock::Estimator.new(order) }
    let(:package) { order.shipments.first.to_package }

    it "gets rates" do
      computed_rates = [
        {
          carrier_code: 'FDX2',
          service: 'FedEx CrazyFast',
          cost: 20.99
        },
        {
          carrier_code: 'FDX1',
          service: 'FedEx SuperFast',
          cost: 10.99
        }
      ]

      expect(SpreeShipwire::Rates).to receive(:compute)
                                        .with(order.ship_address, {order.line_items.first.variant => 1})
                                        .and_return(computed_rates)

      rates = estimator.shipping_rates(package)

      expect(rates.count).to eq(2)

      rate = rates[0]
      expect(rate.carrier_code).to eq('FDX1')
      expect(rate.name).to eq('FedEx SuperFast')
      expect(rate.cost).to eq(10.99)
      expect(rate.selected).to eq(true)

      rate = rates[1]
      expect(rate.carrier_code).to eq('FDX2')
      expect(rate.name).to eq('FedEx CrazyFast')
      expect(rate.cost).to eq(20.99)
      expect(rate.selected).to eq(false)
    end
  end
end
