module SpreeShipwire::StockEstimatorDecorator
  def shipping_rates(package)
    if @order.complete?
      super
    else
      refresh_shipping_rates(package)
    end
  end

private

  def refresh_shipping_rates(package)
    items = map_contents(package)

    begin
      quotes = SpreeShipwire::Rates.compute(@order.ship_address, items)

      rates = quotes.map do |quote|
        Spree::ShippingRate.new(
          name:            format_name(quote),
          shipping_method: find_shipping_method(quote[:service]),
          code:            quote[:code],
          carrier_code:    quote[:carrier_code],
          cost:            quote[:cost]
        )
      end

      choose_default_shipping_rate(rates)
      sort_shipping_rates(rates)
    rescue SpreeShipwire::AddressError => e
      @order.ship_address.update(remote_validation_error: e.message)
      @order.save
      []
    end
  end

  def find_shipping_method(name)
    Spree::ShippingMethod.find_or_create_by(name: name) do |method|
      method.calculator          = Spree::Calculator::FlatRate.new
      method.shipping_categories = [Spree::ShippingCategory.first]
    end
  end

  def format_name(quote)
    service  = quote[:service]
    estimate = quote[:delivery_estimate]
    min, max = estimate[:minimum].to_i, estimate[:maximum].to_i

    delivery = if min == max
                 "#{min} #{'day'.pluralize(min)}"
               else
                 "#{min}-#{max} days"
               end

    "#{service} (#{delivery})"
  end

  def map_contents(package)
    package.contents.reduce({}) do |acc, item|
      if acc[item.variant]
        acc[item.variant] += 1
      else
        acc[item.variant] = 1
      end

      acc
    end
  end
end

Spree::Stock::Estimator.prepend(SpreeShipwire::StockEstimatorDecorator)
