module SpreeShipwire::Rates
  extend self

  def compute(address, line_items=[])
    rate = Shipwire::ShippingRate.new(address: map_address(address),
                                      items: map_line_items(line_items))

    rate.send
    rate.parse_response

    rate.shipping_quotes
  end

private
  def map_address(address)
    {address1: address.address1,
     address2: address.address2,
     city:     address.city,
     state:    address.state.try(:abbr) || address.state_name,
     country:  address.country.iso,
     zip:      address.zipcode}
  end

  def map_line_items(line_items)
    line_items.map do |line|
      {item: line.variant.sku, quantity: line.quantity}
    end
  end
end

