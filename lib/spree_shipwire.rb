require 'spree_core'
require 'shipwire'
require 'spree_shipwire/engine'

module SpreeShipwire
  autoload :Rates, 'spree_shipwire/rates'

  def self.config(&block)
    Shipwire.configure(&block)
  end
end
