module SpreeShipwire::ShippingRateDecorator
  def name
    read_attribute(:name)
  end
end

Spree::ShippingRate.prepend(SpreeShipwire::ShippingRateDecorator)
