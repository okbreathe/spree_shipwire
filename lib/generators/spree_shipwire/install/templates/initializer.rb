SpreeShipwire.config do |config|
  config.username = ENV['SHIPWIRE_USERNAME']
  config.password = ENV['SHIPWIRE_PASSWORD']
  config.server   = ENV['SHIPWIRE_SERVER']
  config.endpoint = ENV['SHIPWIRE_ENDPOINT']
end
