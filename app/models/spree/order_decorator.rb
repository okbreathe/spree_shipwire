module SpreeShipwire::OrderDecorator
  def self.prepended(klass)
    klass.validate :validate_remote_ship_address_error
  end

private
  def validate_remote_ship_address_error
    error = ship_address.try(:remote_validation_error)

    errors.add(:base, error) if error.present?
  end
end

Spree::Order.prepend(SpreeShipwire::OrderDecorator)
