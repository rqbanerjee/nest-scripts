class NestDeviceReading
  @id
  @humidity
  @has_leaf
  @name
  @hvac_mode
  @target_temperature
  @ambient_temperature
  @hvac_state
  @reading_time

  attr_accessor :id, :humidity, :has_leaf, :name, :hvac_mode, :target_temperature
  attr_accessor :ambient_temperature, :hvac_state, :reading_time

  def initialize(id, json_blob)
    @id = id
    @name = json_blob["name_long"]
    @humidity = json_blob["humidity"]
    @has_leaf = json_blob["has_leaf"].eql?('true')? 1 : 0
    @hvac_mode = json_blob["hvac_mode"]
    @target_temperature = json_blob["target_temperature_f"]
    @ambient_temperature = json_blob["ambient_temperature_f"]
    @hvac_state = json_blob["hvac_state"]
    @reading_time = DateTime.now
  end
end

