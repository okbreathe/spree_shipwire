require 'spree_core'
require 'shipwire'
require 'spree_shipwire/engine'

module SpreeShipwire
  def self.config(&block)
    Shipwire.configure(block)
  end
end
