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

		begin
            @client = Mysql2::Client.new(:host => @db_host, :username => @db_user, :password => @db_password)
            results = @client.query("SELECT * FROM nest_thermostat_readings")
            pp results
		rescue Mysql::Error => e
    		puts e.errno
    		puts e.error
		ensure
    		@conn.close if @conn
		end
	end
end
