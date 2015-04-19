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
end
