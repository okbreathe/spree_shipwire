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
  ADDRESS_WARNING  = 'Could not verify shipping address'
  CONNECTION_ERROR = 'Unable to connect to Shipwire'
  RATE_ERROR       = 'Unable to get shipping rates from Shipwire'
  UNRECOGNIZED_SKU = /Unrecognized SKU/

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
      {code: line.variant.sku, quantity: line.quantity}
    end
  end

  def raise_if_invalid(response)
    if response.is_a?(Faraday::Response)
      warning = parse_warning(response)

      if warning =~ UNRECOGNIZED_SKU
        raise SpreeShipwire::UnrecognizedSKUError.new(warning)
      elsif warning == ADDRESS_WARNING
        raise SpreeShipwire::AddressError.new(warning)
      end
    else
      messages = response.join(', ')

      raise SpreeShipwire::ConnectionError.new(messages) if response.include?(CONNECTION_ERROR)
      raise SpreeShipwire::RateError.new(messages) if response.include?(RATE_ERROR)
    end
  end

  def parse_warning(response)
    xml = Nokogiri::XML(response.body)

    xml.xpath('//Warning').try(:text)
  end
end

