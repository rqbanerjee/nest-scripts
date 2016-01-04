require 'yaml'
require_relative 'nest_client'

def load_config_file(file_name)
  config_vals = nil
  begin
    config_vals = YAML.load_file(file_name)
  rescue Exception => e
    puts "UNABLE TO LOAD #{file_name}: #{e}."
    exit -1
  end
  config_vals
end

config_vals = load_config_file("config.yml")
nest_client = NestClient.new(config_vals["NEST_ID"], config_vals["NEST_SECRET"], config_vals["NEST_PIN"])

puts "TEST:"
puts nest_client.inspect

puts "Getting access token..."
nest_client.get_access_token

puts "Getting devices"
nest_client.get_devices
