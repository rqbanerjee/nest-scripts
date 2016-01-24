-- Create a table to store thermostat device readings
-- https://github.com/rqbanerjee/nest-scripts/
-- author: rajatb

create table if not exists nest_thermostat_readings (
    id int unsigned auto_increment not null primary key,
    humidity int unsigned not null,
    has_leaf bool not null,
    name varchar(255) not null,
    hvac_mode varchar(10) nut null,
    hvac_state varchar(10) not null,
    target_temperature float not null,
    ambient_temperature float not null,
    reading_time varchar(24) not null,

    timestamp not null default reading_timestamp on update reading_timestamp
            comment 'The time at which this reading was inserted',
);

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
