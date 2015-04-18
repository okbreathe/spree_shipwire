module SpreeShipwire::Rates
  extend self

  def compute(address, line_items=[])
    rate = Shipwire::ShippingRate.new(address: map_address(address),
                                      items: map_line_items(line_items))

    response = rate.send
    raise_if_invalid(response)
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

  def raise_if_invalid(response)
    messages = response.join(', ')

    raise SpreeShipwire::ConnectionError.new(messages) if response.include?('Unable to connect to Shipwire')
    raise SpreeShipwire::RateError.new(messages) if response.include?('Unable to get shipping rates from Shipwire')
  end
end

