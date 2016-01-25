require 'yaml'
require_relative 'lib/nest_client'
require_relative 'lib/nest_config'

nest_config = NestConfig.new("config.yml")
nest_client = NestClient.new(nest_config)
thermostats = []

puts "NEST_CLIENT:"
puts nest_client.inspect

if nest_config.nest_token.nil?
    puts "No valid access token could be created. Quitting."
    exit -1
else
    puts "Getting devices"
    thermostats = nest_client.get_devices
    thermostats.each do |t|
        puts "Details for thermostat #{t.id} ( #{t.name} )"
        pp t
    end

end

begin
    require_relative 'lib/db_writer'
    db_writer = DbWriter.new(nest_config)
rescue Gem::LoadError => e
    puts "****\n Not going attempting to connect to mysql since mysql2 gem is not installed \n****"
	puts e
end


exit 0 #success
