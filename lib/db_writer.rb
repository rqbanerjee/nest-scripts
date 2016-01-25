require 'mysql2'

class DbWriter
    @db_host
    @db_user
    @db_password
    @db_name
    @client

    def initialize(nest_config)
        @db_host = nest_config.db_host
        @db_user = nest_config.db_user
        @db_password = nest_config.db_password

        #fixed database name. see README.txt
        @db_name = 'thermo'
        init_connection
    end

    def init_connection
        begin
            @client = Mysql2::Client.new(:host => @db_host, :username => @db_user, :password => @db_password, :database => @db_name)
        rescue Exception => e
            puts e.errno
            puts e.error
        ensure
            @conn.close if @conn
        end
    end

    def store_readings(thermostats)
        if @client.nil?
            init_connection
        end

        if @client.nil?
            puts "Tried twice to start DB connection and failed. exiting"
            exit -1
        end

        thermostats.each do |t|
            query = create_query_line(t)
            puts "CALLING #{query}"
            @client.query(query)
        end
    end

    def create_query_line(device_reading)
        str = "INSERT INTO nest_thermostat_readings "
        str += "(uid, humidity, has_leaf, name, hvac_mode, hvac_state, target_temperature, ambient_temperature) "
        str += " VALUES ("
	str += "\'" + device_reading.id + "\', "
        str += device_reading.humidity.to_s + ", " + device_reading.has_leaf.to_s
	str += ", \'" + device_reading.name
        str += "\', \'" + device_reading.hvac_mode + "\', \'" + device_reading.hvac_state + "\', "
        str += device_reading.target_temperature.to_s + ", " + device_reading.ambient_temperature.to_s + ")"
        str
    end

end

