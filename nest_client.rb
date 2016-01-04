require 'net/http'
require 'httparty'
require_relative 'nest_device'

class NestClient
  include HTTParty
  format :json

  @nest_id = nil
  @nest_secret = nil
  @nest_pin = nil
  @access_token = nil

  def initialize(nest_id, nest_secret, nest_pin)
    @nest_id = nest_id
    @nest_secret = nest_secret
    @nest_pin = nest_pin
  end

  def get_access_token
    options = {"code" => @nest_pin, "client_id" => @nest_id, "client_secret" => @nest_secret, "grant_type" => "authorization_code"}
    url = 'https://api.home.nest.com/oauth2/access_token'
    resp = HTTParty.post(url, body: options)

    if resp.code == 200
      @access_token = resp.parsed_response["access_token"]
      puts "Set access token: #{@access_token}"
      return @access_token
    end

    if resp.code == 400
      descr = resp.parsed_response["error_description"]
      puts "Error getting authorization code: #{descr}."
      if descr.eql? "authorization code not found"
        puts "NOTE: Your PIN has probably expired"
      end
    end
  end

  def get_devices
    thermostats = []
    if @access_token.nil?
      get_access_token
    end

    url = "https://developer-api.nest.com/devices?auth=#{@access_token}"
    options = {"Authorization" => "Bearer #{@access_token}" }
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
    "Nest ID: #{@nest_id}, Nest Secret: #{@nest_secret}, Nest PIN: #{@nest_pin}"
  end
end

