require 'yaml'

class NestConfig
    @file_name
    @nest_id
    @nest_secret
    @nest_pin
    @nest_token
    @nest_token_expiry
    @db_host
    @db_user
    @db_password

    attr_accessor :nest_id, :nest_secret, :nest_pin, :nest_token, :db_host, :db_user, :db_password

    def initialize(file_name)
        @file_name = file_name
        config_vals = load_config_file(@file_name)
        @nest_id = config_vals["NEST_ID"]
        @nest_secret = config_vals["NEST_SECRET"]
        @nest_pin = config_vals["NEST_PIN"]
        if config_vals.include? "NEST_TOKEN" and not config_vals["NEST_TOKEN"].nil?
            @nest_token = config_vals["NEST_TOKEN"]
            @nest_token_expiry = config_vals["NEST_TOKEN_EXPIRY"]
            puts "Token found in config file: #{@nest_token}"
        else
            puts "No token found in config file. Trying to get one"
            set_nest_token(get_access_token)
        end
        @db_host = config_vals["DB_HOST"]
        @db_user = config_vals["DB_USER"]
        @db_password = config_vals["DB_PASSWORD"]
    end

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

    def set_nest_token(token)
        @nest_token = token
        write_config_to_file
    end

    def get_access_token
        options = {"code" => @nest_pin, "client_id" => @nest_id, "client_secret" => @nest_secret, "grant_type" => "authorization_code"}
        url = 'https://api.home.nest.com/oauth2/access_token'
        resp = HTTParty.post(url, body: options)
        if resp.code == 200
            @access_token = resp.parsed_response["access_token"]
            expires_in = resp.parsed_response["expires_in"]
            @nest_token_expiry = DateTime.now + Rational(expires_in, 86400) #api call returns seconds from now when token expires
            puts "parsed response = #{resp.parsed_response.to_s}."
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

    def write_config_to_file
        config_vals = {
            "NEST_ID" => @nest_id,
            "NEST_SECRET" => @nest_secret,
            "NEST_PIN" => @nest_pin,
            "NEST_TOKEN" => @nest_token,
            "NEST_TOKEN_EXPIRY" => @nest_token_expiry,
            "DB_HOST" => @db_host,
            "DB_USER" => @db_user,
            "DB_PASSWORD" => @db_password
        }
        File.open(@file_name, 'w+') {|f| f.write(config_vals.to_yaml) }
        puts "wrote config values to #{@file_name}."
    end

end

