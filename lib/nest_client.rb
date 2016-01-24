require 'net/http'
require 'httparty'
require_relative 'nest_device'

class NestClient
    include HTTParty
    format :json

    @nest_token = nil

    def initialize(nest_config)
        @nest_token = nest_config.nest_token
    end

    def get_devices
        thermostats = []

        url = "https://developer-api.nest.com/devices?auth=#{@nest_token}"
        options = {"Authorization" => "Bearer #{@nest_token}" }
        resp = HTTParty.get(url, body: options)
        if resp.code != 200
            puts "Failed to retrieve devices. Error: #{resp.parsed_response["error_description"] } "
            return []
        end

        parsed = resp.parsed_response
        thermostats_hash = parsed["thermostats"]
        puts "Retrieved #{thermostats_hash.keys.size} thermostats"
        thermostats_hash.each {|name, properties| thermostats << NestDevice.new(name, properties) }
        thermostats
    end

    def to_s
        puts "nest_token = #{@nest_token}."
    end
end

