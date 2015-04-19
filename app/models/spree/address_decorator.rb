module SpreeShipwire::AddressDecorator
  def self.prepended(klass)
    klass.before_validation :clear_remote_error
  end

private
  def clear_remote_error
    address_changed = address1_changed? || address2_changed? || city_changed? || state_id_changed? || state_name_changed? || country_id_changed? || zipcode_changed?

    self.remote_validation_error = nil if address_changed && !remote_validation_error_changed?
  end
end

Spree::Address.prepend(SpreeShipwire::AddressDecorator)
