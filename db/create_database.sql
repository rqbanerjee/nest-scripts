-- Create a table to store thermostat device readings
-- https://github.com/rqbanerjee/nest-scripts/
-- author: rajatb

create table if not exists nest_thermostat_readings (
    id int unsigned auto_increment not null primary key,
    uid varchar(255) not null comment 'NEST assigned unique id',
    humidity int unsigned not null,
    has_leaf bool not null,
    name varchar(255) not null,
    hvac_mode varchar(10),
    hvac_state varchar(10),
    target_temperature float default 0,
    ambient_temperature float default 0,
    reading_time varchar(24) not null,

    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
        comment 'The time at which this reading was inserted');

/*
   @id
   @humidity
   @has_leaf
   @name
   @hvac_mode
   @target_temperature_f
   @ambient_temperature_f
   @hvac_state
   @reading_time
*/
