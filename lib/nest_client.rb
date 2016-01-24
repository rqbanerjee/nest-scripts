require 'net/http'
require 'httparty'
require 'pp'
require_relative 'nest_device_reading'

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
            puts "Failed to retrieve devices. Error: #{resp.parsed_response['error_description'] } "
            return []
        end

        parsed = resp.parsed_response
        thermostats_hash = parsed["thermostats"]
        puts "Retrieved #{thermostats_hash.keys.size} thermostats"
        thermostats_hash.each do |id, properties|
            thermostats << NestDeviceReading.new(id, properties)
        end
        thermostats
    end

    # Turns out that the call to api/thermostats/<device-id> gives the same info as a call to /devices, no more.
    # because of that, this function isn't useful yet
    def get_thermostat_details(device_id)
        details = {}
        url = "https://developer-api.nest.com/devices/thermostats/#{device_id}?auth=#{@nest_token}"
        puts url
        options = {"Authorization" => "Bearer #{@nest_token}" }
        resp = HTTParty.get(url, body: options)
        if resp.code != 200
            puts "Failed to retrieve thermostat details. Error: #{resp.parsed_response['error_description'] } "
            return details
        end
        # reuse the same logic from get_devices parsing the response hash. same responses.
        details
    end

    def to_s
        puts "nest_token = #{@nest_token}."
    end
end

