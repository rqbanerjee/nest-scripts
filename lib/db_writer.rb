require 'mysql'

class DbWriter
	@db_host
	@db_user
	@db_password
	@db_name
	@conn

	def initialize(nest_config)
		@db_host = nest_config.db_host
		@db_user = nest_config.db_user
		@db_password = nest_config.db_password

		#fixed database name. see README.txt
		@db_name = 'thermo'

		begin
			@conn = Mysql.new @db_host, @db_user, @db_password
			puts @conn.get_server_info
    			rs = @conn.query 'SELECT * FROM nest_thermostat_readings'
    			puts rs.fetch_row    
		rescue Mysql::Error => e
    			puts e.errno
    			puts e.error
		ensure
    			@conn.close if @conn
		end
	end
end
