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
    quotes = SpreeShipwire::Rates.compute(@order.ship_address, items)

    rates = quotes.map do |quote|
      Spree::ShippingRate.new(
        name:         format_name(quote),
        carrier_code: quote[:carrier_code],
        cost:         quote[:cost]
      )
    end

    choose_default_shipping_rate(rates)
    sort_shipping_rates(rates)
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
