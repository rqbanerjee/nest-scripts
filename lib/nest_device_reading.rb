class NestDeviceReading
  @id
  @humidity
  @has_leaf
  @name
  @hvac_mode
  @target_temperature_f
  @ambient_temperature_f
  @hvac_state
  @reading_time

  attr_accessor :id, :name

  def initialize(id, json_blob)
    @id = id
    @name = json_blob["name_long"]
    @humidity = json_blob["humidity"]
    @has_leaf = json_blob["has_leaf"]
    @hvac_mode = json_blob["hvac_mode"]
    @target_temperature_f = json_blob["target_temperature_f"]
    @ambient_temparature_f = json_blob["ambient_temperature_f"]
    @hvac_state = json_blob["hvac_state"]
    @reading_time = DateTime.now
  end
end

