SpreeShipwire.config do |config|
  # account email address
  config.username = ENV['SHIPWIRE_USERNAME']

  # account password
  config.password = ENV['SHIPWIRE_PASSWORD']

  # For testing use: Test
  # For production use: Production
  config.server   = ENV['SHIPWIRE_SERVER']

  # For testing use: https://api.beta.shipwire.com/exec/
  # For production use: https://api.shipwire.com/exec/
  config.endpoint = ENV['SHIPWIRE_ENDPOINT']
end
