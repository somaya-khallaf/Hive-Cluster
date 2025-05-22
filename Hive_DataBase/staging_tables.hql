-- Create staging database if it doesn't exist
CREATE DATABASE IF NOT EXISTS airline_dwh_staging;
USE airline_dwh_staging;
-- Airport dimension staging
CREATE EXTERNAL TABLE IF NOT EXISTS dim_airport_staging (
    airport_key INT,
    airport_name STRING,
    airport_city STRING,
    airport_country STRING,
    airport_region STRING,
    airport_type STRING,
    airport_latitude DOUBLE,
    airport_longitude DOUBLE,
    airport_hub_status STRING,
    airport_Runway_available BOOLEAN,
    airport_no_of_terminals INT
)
STORED AS ORC
LOCATION '/user/hive/warehouse/airline_dwh_staging.db/dim_AirPort';

-- Aircraft dimension staging
CREATE EXTERNAL TABLE IF NOT EXISTS dim_aircraft_staging (
    aircraft_key            INT, 
    aircraft_manufacturer   STRING,  
    aircraft_capacity       INT,      
    aircraft_model          STRING,     
    aircraft_enginetype     STRING,
    aircraft_status         STRING,        
    economy_seats_range     STRING,      
    business_seats_range    STRING,   
    max_miles               INT,    
    max_speed               INT  
)
STORED AS ORC
LOCATION '/user/hive/warehouse/airline_dwh_staging.db/dim_AirCraft';


-- Fare basis staging
CREATE EXTERNAL TABLE IF NOT EXISTS dim_farebasis_staging (
    farebasis_key INT,
    farebasis_class STRING,
    farebasis_type STRING,
    Refundability STRING,
    ChangeFee INT,
    BaggageAllowance INT,
    PriorityBoarding BOOLEAN
)
STORED AS ORC
LOCATION '/user/hive/warehouse/airline_dwh_staging.db/dim_FareBase';

-- Passenger profile history staging
CREATE EXTERNAL TABLE IF NOT EXISTS dim_passenger_profile_history_staging (
    profile_history_key INT,
    profile_key INT,
    frequent_flyer_tier STRING,
    home_airport STRING,
    lifetime_mileage_tier STRING,
    start_date DATE,
    end_date DATE
)
STORED AS ORC
LOCATION '/user/hive/warehouse/airline_dwh_staging.db/dim_passenger_profile_history';

-- Passenger staging
CREATE EXTERNAL TABLE IF NOT EXISTS dim_passenger_staging (
    passenger_key INT,
    passenger_id INT,
    passenger_national_id STRING,
    passenger_passport_id STRING,
    passenger_firstname STRING,
    passenger_lastname STRING,
    passenger_dob DATE,
    passenger_city STRING,
    passenger_nationality STRING,
    passenger_country STRING,
    passenger_email STRING,
    passenger_phoneno STRING,
    passenger_gender STRING,
    passenger_language STRING,
    passenger_marital_status STRING
)
STORED AS ORC
LOCATION '/user/hive/warehouse/airline_dwh_staging.db/dim_Passenger';

-- Promotions staging
CREATE EXTERNAL TABLE IF NOT EXISTS dim_promotion_staging (
    promotion_id INT,
    promotion_key INT,
    promotion_type STRING,
    promotion_target_segment STRING,
    promotion_channel STRING,
    promotion_start_date DATE,
    promotion_end_date DATE,
    is_current STRING,
    discount DECIMAL(10, 2)
)
STORED AS ORC
LOCATION '/user/hive/warehouse/airline_dwh_staging.db/dim_promotion';

-- Channel staging
CREATE EXTERNAL TABLE IF NOT EXISTS dim_channel_staging (
    channel_key INT,
    channel_name STRING,
    channel_type STRING
)
STORED AS ORC
LOCATION '/user/hive/warehouse/airline_dwh_staging.db/dim_channel';

-- Country specific date staging
CREATE EXTERNAL TABLE IF NOT EXISTS dim_country_specific_date_staging (
    date_key INT,
    country_key INT,
    country_name STRING,
    civil_name STRING,
    civil_holiday_flag STRING,
    civil_holiday_name STRING,
    religious_holiday_flag STRING,
    religious_holiday_name STRING,
    weekday_indicator STRING,
    season_name STRING
)
STORED AS ORC
LOCATION '/user/hive/warehouse/airline_dwh_staging.db/dim_country_specific_date';

-- Date dimension staging
CREATE EXTERNAL TABLE IF NOT EXISTS dim_date_staging (
    DateKey INT,
    Full_date DATE,
    DayNumber INT,
    DayName STRING,
    monthName STRING,
    yearNo INT,
    season STRING,
    quarter INT
)
STORED AS ORC
LOCATION '/user/hive/warehouse/airline_dwh_staging.db/dim_date';

-- Reservation fact staging
CREATE EXTERNAL TABLE IF NOT EXISTS fact_reservation_staging (
    Reservation_Key INT,
    ticket_id INT,
    channel_key INT,
    promotion_key INT,
    passenger_key INT,
    fare_basis_key INT,
    aircraft_key INT,
    source_airport INT,
    destination_airport INT,
    reservation_date_key INT,
    departure_date_key INT,
    departure_time TIMESTAMP,
    Reservation_timestamp TIMESTAMP,
    payment_method STRING,
    seat_no STRING,
    Promotion_Amount DECIMAL(10,2),
    tax_amount DECIMAL(10,2),
    Operational_Fees DECIMAL(10,2),
    Cancelation_Fees DECIMAL(10,2),
    Fare_Price DECIMAL(10,2),
    Final_Price DECIMAL(10,2),
    Is_Cancelled INT
)
STORED AS ORC
LOCATION '/user/hive/warehouse/airline_dwh_staging.db/fact_reservation';

-- Passenger profile staging
CREATE EXTERNAL TABLE IF NOT EXISTS dim_passenger_profile_staging (
    profile_key INT,
    frequent_flyer_tier STRING,
    home_airport STRING,
    lifetime_mileage_tier STRING,
    points INT
)
STORED AS ORC
LOCATION '/user/hive/warehouse/airline_dwh_staging.db/dim_Passenger_Profile';