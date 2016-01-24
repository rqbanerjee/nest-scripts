require 'yaml'
require_relative 'lib/nest_client'
require_relative 'lib/nest_config'

nest_config = NestConfig.new("config.yml")
nest_client = NestClient.new(nest_config)

puts "NEST_CLIENT:"
puts nest_client.inspect

if nest_config.nest_token.nil?
    puts "No valid access token could be created. Quitting."
    exit -1
else
    puts "Getting devices"
    thermostats = nest_client.get_devices
    thermostats.each {|t| puts t.inspect}
end

exit 0 #success
