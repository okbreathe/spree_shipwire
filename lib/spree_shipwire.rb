require 'spree_core'
require 'shipwire'
require 'spree_shipwire/engine'

module SpreeShipwire
  autoload :Rates,           'spree_shipwire/rates'
  autoload :ConnectionError, 'spree_shipwire/errors'
  autoload :RateError,       'spree_shipwire/errors'

  def self.config(&block)
    Shipwire.configure(&block)
  end
end
