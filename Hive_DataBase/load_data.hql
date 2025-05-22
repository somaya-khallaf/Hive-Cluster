USE Airline_DWH;

-- Load data into ACID tables (using INSERT instead of LOAD DATA for transactional support)
INSERT INTO TABLE dim_airport
SELECT * FROM airline_dwh_staging.dim_airport_staging;


INSERT OVERWRITE TABLE dim_aircraft PARTITION(aircraft_status)
SELECT 
    aircraft_key,  
    aircraft_manufacturer,
    aircraft_capacity,      
    aircraft_model, 
    aircraft_enginetype,      
    economy_seats_range,      
    business_seats_range,      
    max_miles  ,    
    max_speed ,
    aircraft_status  
FROM airline_dwh_staging.dim_aircraft_staging;

INSERT OVERWRITE TABLE dim_farebasis PARTITION(farebasis_class)
SELECT 
    farebasis_key,
    farebasis_type,
    Refundability,
    ChangeFee,
    BaggageAllowance,
    PriorityBoarding,
    farebasis_class  
FROM airline_dwh_staging.dim_farebasis_staging;

INSERT OVERWRITE TABLE dim_passenger_profile_history PARTITION(profile_key)
SELECT 
    profile_history_key,
    frequent_flyer_tier,
    home_airport,
    lifetime_mileage_tier,
    start_date,
    end_date,
    profile_key
FROM airline_dwh_staging.dim_passenger_profile_history_staging;

INSERT INTO TABLE dim_passenger
SELECT * FROM airline_dwh_staging.dim_passenger_staging;

INSERT INTO TABLE dim_promotions
SELECT * FROM airline_dwh_staging.dim_promotion_staging;

-- Load data into non-ACID tables
INSERT OVERWRITE TABLE dim_channel PARTITION(channel_type)
SELECT 
    channel_key,
    channel_name,
    channel_type
FROM airline_dwh_staging.dim_channel_staging;

INSERT OVERWRITE TABLE dim_country_specific_date
SELECT * FROM airline_dwh_staging.dim_country_specific_date_staging;

INSERT OVERWRITE TABLE dim_date
SELECT * FROM airline_dwh_staging.dim_date_staging;

INSERT OVERWRITE TABLE fact_reservation PARTITION(reservation_year, reservation_month)
SELECT 
    r.Reservation_Key,
    r.ticket_id,
    r.channel_key,
    r.promotion_key,
    r.passenger_key,
    r.fare_basis_key,
    r.aircraft_key,
    r.source_airport,
    r.destination_airport,
    r.departure_date_key,
    r.departure_time,
    r.Reservation_timestamp,
    r.payment_method,
    r.seat_no,
    r.Promotion_Amount,
    r.tax_amount,
    r.Operational_Fees,
    r.Cancelation_Fees,
    r.Fare_Price,
    r.Final_Price,
    r.Is_Cancelled,
    YEAR(d.Full_date) AS reservation_year,
    MONTH(d.Full_date) AS reservation_month
FROM airline_dwh_staging.fact_reservation_staging r
JOIN airline_dwh_staging.dim_date_staging d ON r.reservation_date_key = d.DateKey;

INSERT OVERWRITE TABLE dim_passenger_profile
SELECT * FROM airline_dwh_staging.dim_passenger_profile_staging;