-- Create main data warehouse database
CREATE DATABASE IF NOT EXISTS Airline_DWH;
USE Airline_DWH;

-- ACID-compliant airport dimension table (Type 1)
CREATE TABLE IF NOT EXISTS dim_airport (
    airport_key INT COMMENT 'Primary key',
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
CLUSTERED BY (airport_key) INTO 5 BUCKETS
STORED AS ORC
TBLPROPERTIES ('transactional'='true');

-- ACID-compliant aircraft dimension table
CREATE TABLE IF NOT EXISTS dim_aircraft (
    aircraft_key            INT COMMENT 'Primary key', 
    aircraft_manufacturer   STRING,  
    aircraft_capacity       INT,      
    aircraft_model          STRING,     
    aircraft_enginetype     STRING,       
    economy_seats_range     STRING,      
    business_seats_range    STRING,   
    max_miles               INT,    
    max_speed               INT 
)
PARTITIONED BY (aircraft_status STRING)
CLUSTERED BY (aircraft_key) INTO 5 BUCKETS
STORED AS ORC
TBLPROPERTIES ('transactional'='true');

-- ACID-compliant fare basis dimension table (Type 1)
CREATE TABLE IF NOT EXISTS dim_farebasis (
    farebasis_key INT COMMENT 'Primary key',
    farebasis_type STRING,
    Refundability STRING,
    ChangeFee INT,
    BaggageAllowance INT,
    PriorityBoarding BOOLEAN
)
PARTITIONED BY (farebasis_class STRING)
CLUSTERED BY (farebasis_key) INTO 10 BUCKETS
STORED AS ORC
TBLPROPERTIES ('transactional'='true');

-- ACID-compliant passenger profile history dimension table (Type 2)
CREATE TABLE IF NOT EXISTS dim_passenger_profile_history (
    profile_history_key INT COMMENT 'Primary key',
    frequent_flyer_tier STRING,
    home_airport STRING,
    lifetime_mileage_tier STRING,
    start_date DATE,
    end_date DATE
)
PARTITIONED BY (profile_key INT) 
CLUSTERED BY (profile_history_key) INTO 10 BUCKETS
STORED AS ORC
TBLPROPERTIES ('transactional'='true');

-- ACID-compliant passenger dimension table (Type 1)
CREATE TABLE IF NOT EXISTS dim_passenger (
    passenger_key INT COMMENT 'Primary key',
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
CLUSTERED BY (passenger_key) INTO 10 BUCKETS
STORED AS ORC
TBLPROPERTIES ('transactional'='true');

-- ACID-compliant promotions dimension table (Type 2)
CREATE TABLE IF NOT EXISTS dim_promotions (
    promotion_id INT,
    promotion_key INT COMMENT 'Primary key',
    promotion_type STRING,
    promotion_target_segment STRING,
    promotion_channel STRING,
    promotion_start_date DATE,
    promotion_end_date DATE,
    is_current STRING,
    discount DECIMAL(10, 2)
)
CLUSTERED BY (promotion_key) INTO 5 BUCKETS
STORED AS ORC
TBLPROPERTIES ('transactional'='true');

-- Non-ACID channel dimension
CREATE EXTERNAL TABLE IF NOT EXISTS dim_channel (
    channel_key INT COMMENT 'Primary key',
    channel_name STRING
)
PARTITIONED BY (channel_type STRING)
CLUSTERED BY (channel_key) INTO 3 BUCKETS
STORED AS ORC;

-- Non-ACID country specific date dimension
CREATE EXTERNAL TABLE IF NOT EXISTS dim_country_specific_date (
    date_key INT COMMENT 'Primary key',
    country_key INT COMMENT 'Foreign key to country dimension',
    country_name STRING,
    civil_name STRING,
    civil_holiday_flag STRING,
    civil_holiday_name STRING,
    religious_holiday_flag STRING,
    religious_holiday_name STRING,
    weekday_indicator STRING,
    season_name STRING
)
CLUSTERED BY (date_key) INTO 3 BUCKETS
STORED AS ORC;

-- Non-ACID date dimension
CREATE EXTERNAL TABLE IF NOT EXISTS dim_date (
    DateKey INT COMMENT 'Primary key',
    Full_date DATE,
    DayNumber INT,
    DayName STRING,
    monthName STRING,
    yearNo INT,
    season STRING,
    quarter INT
)
CLUSTERED BY (DateKey) INTO 10 BUCKETS
STORED AS ORC;

-- Non-ACID fact reservation table
-- Non-ACID fact reservation table
CREATE EXTERNAL TABLE IF NOT EXISTS fact_reservation (
    Reservation_Key INT COMMENT 'Primary key',
    ticket_id INT,
    channel_key INT COMMENT 'Foreign key to dim_channel',
    promotion_key INT COMMENT 'Foreign key to dim_promotions',
    passenger_key INT COMMENT 'Foreign key to dim_passenger',
    fare_basis_key INT COMMENT 'Foreign key to dim_farebasis',
    aircraft_key INT,
    source_airport INT COMMENT 'Foreign key to dim_airport',
    destination_airport INT COMMENT 'Foreign key to dim_airport',
    departure_date_key INT COMMENT 'Foreign key to dim_date',
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
PARTITIONED BY (
    reservation_year INT COMMENT 'Year derived from reservation_date_key',
    reservation_month INT COMMENT 'Month derived from reservation_date_key'
)
STORED AS ORC;

-- Non-ACID passenger profile dimension
CREATE EXTERNAL TABLE IF NOT EXISTS dim_passenger_profile (
    profile_key INT COMMENT 'Primary key',
    frequent_flyer_tier STRING,
    home_airport STRING,
    lifetime_mileage_tier STRING,
    points INT
)
CLUSTERED BY (profile_key) INTO 5 BUCKETS
STORED AS ORC;