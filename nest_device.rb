class NestDevice
  @id
  @humidity
  @has_leaf
  @name
  @hvac_mode
  @target_temperature_f 
  @ambient_temperature_f
  
  def initialize(name, json_blob)
    @name = name
    @humidity = json_blob["humidity"]
    @has_leaf = json_blob["has_leaf"]
    @hvac_mode = json_blob["hvac_mode"]
    @target_temperature_f = json_blob["target_temperature_f"]
    @ambient_temparature_f = json_blob["ambient_temperature_f"]
  end
end

