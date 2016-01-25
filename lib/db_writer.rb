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
            #@client.
            puts create_query_line(t)
        end
    end

    def create_query_line(device_reading)
        str = "INSERT INTO nest_thermostat_readings VALUES "
        str += "(humidity, has_leaf, name, hvac_mode, hvac_state, target_temperature, ambient_temperature) "
        str += " VALUES ("
        str += device_reading.humidity + ", " + device_reading.has_leaf + ", \'" + device_reading.name
        str += "\', \'" + device_reading.hvac_mode + "\', \'" + device_reading.hvac_state + "\', "
        str += target_temperature + ", " + ambient_temperatore + ")"
        str
    end

end

=begin
    id int unsigned auto_increment not null primary key,
        humidity int unsigned not null,
            has_leaf bool not null,
                name varchar(255) not null,
                    hvac_mode varchar(10),
                        hvac_state varchar(10),
                            target_temperature float default 0,
                                ambient_temperature float default 0,
                                    reading_time varchar(24) not null,


#<NestDeviceReading:0x000000010ada10
# @ambient_temparature_f=70,
#  @has_leaf=false,
#   @humidity=40,
#    @hvac_mode="heat",
#     @hvac_state="off",
#      @id="qSCbq8jPiw4Eb7HnYeZlVuGRrpLs4Fyp",
#       @name="Bedroom Thermostat",
#        @reading_time=
#          #<DateTime: 2016-01-25T02:36:03+00:00 ((2457413j,9363s,88763566n),+0s,2299161j)>,
#           @target_temperature_f=70>
#
=end

