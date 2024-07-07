-- ride_id is primary key
SELECT
COUNT(*) - COUNT(ride_id) AS ride_id
FROM `casestudy1-427906.tripdata.combined_data`

-- Ensure each ride_id has exactly 16 characters
SELECT COUNT(ride_id) AS ride_count
FROM `casestudy1-427906.tripdata.combined_data`
WHERE LENGTH(ride_id) != 16;

-- Ensure no duplicate entries
SELECT ride_id,
  COUNT(*) AS duplicate_ride_id
FROM `casestudy1-427906.tripdata.combined_data`
GROUP BY ride_id
HAVING
  COUNT(*) > 1;

-- Identify the number of NULL vlaues in each remaining columns
SELECT
COUNT(ride_id) - COUNT(rideable_type) AS rideable_type,
COUNT(ride_id) - COUNT(started_at) AS started_at,
COUNT(ride_id) - COUNT(ended_at) AS ended_at,
COUNT(ride_id) - COUNT(start_station_name) AS start_station_name,
COUNT(ride_id) - COUNT(start_station_id) AS start_station_id,
COUNT(ride_id) - COUNT(end_station_name) AS end_station_name,
COUNT(ride_id) - COUNT(end_station_id) AS end_staion_id,
COUNT(ride_id) - COUNT(start_lat) AS start_lat,
COUNT(ride_id) - COUNT(start_lng) AS start_lng,
COUNT(ride_id) - COUNT(end_lat) AS end_lat,
COUNT(ride_id) - COUNT(end_lng) AS end_lng,
COUNT(ride_id) - COUNT(member_casual) AS member_casual,
FROM `casestudy1-427906.tripdata.combined_data`;

-- Data cleaning and adding new columns
CREATE OR REPLACE TABLE `casestudy1-427906.tripdata.filtered_data` AS -- Create a new table titled 'filtered_data'
SELECT *,
       TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS ride_length, -- New 'ride_length' column
       FORMAT_TIMESTAMP('%b', started_at) AS month, -- New 'month' column
       FORMAT_TIMESTAMP('%a', started_at) AS day_of_week, -- New 'day_of_week' column 
       EXTRACT(HOUR FROM started_at) AS hour_of_day, -- New 'hour_of_day' column
FROM `casestudy1-427906.tripdata.combined_data`
WHERE rideable_type IS NOT NULL  -- Remove rows with NULL values
  AND started_at IS NOT NULL
  AND ended_at IS NOT NULL
  AND start_station_name IS NOT NULL
  AND start_station_id IS NOT NULL
  AND end_station_name IS NOT NULL
  AND end_station_id IS NOT NULL
  AND start_lat IS NOT NULL
  AND start_lng IS NOT NULL
  AND end_lat IS NOT NULL
  AND end_lng IS NOT NULL
  AND member_casual IS NOT NULL
  AND TIMESTAMP_DIFF(ended_at, started_at, MINUTE) <= 1440  -- Remove rows where 'ride_length' more than a day
  AND TIMESTAMP_DIFF(ended_at, started_at, MINUTE) >= 1; -- Remove rows where 'ride_length' less than one minute

-- Ensure the number of months/days/hours is correct
SELECT
  COUNT(DISTINCT month) AS no_of_months,
  COUNT(DISTINCT day_of_week) AS no_of_days,
  COUNT(DISTINCT hour_of_day) AS no_of_hours,
FROM `casestudy1-427906.tripdata.filtered_data`;

-- Enusre no NULL values in each column
SELECT
  COUNT(ride_id) - COUNT(rideable_type) AS rideable_type,
  COUNT(ride_id) - COUNT(started_at) AS started_at,
  COUNT(ride_id) - COUNT(ended_at) AS ended_at,
  COUNT(ride_id) - COUNT(start_station_name) AS start_station_name,
  COUNT(ride_id) - COUNT(start_station_id) AS start_station_id,
  COUNT(ride_id) - COUNT(end_station_name) AS end_station_name,
  COUNT(ride_id) - COUNT(end_station_id) AS end_staion_id,
  COUNT(ride_id) - COUNT(start_lat) AS start_lat,
  COUNT(ride_id) - COUNT(start_lng) AS start_lng,
  COUNT(ride_id) - COUNT(end_lat) AS end_lat,
  COUNT(ride_id) - COUNT(end_lng) AS end_lng,
  COUNT(ride_id) - COUNT(member_casual) AS member_casual,
  COUNT(ride_id) - COUNT(ride_length) AS ride_length,
  COUNT(ride_id) - COUNT(month) AS month,
  COUNT(ride_id) - COUNT(day_of_week) AS day_of_week,
  COUNT(ride_id) - COUNT(hour_of_day) AS hour_of_day,
FROM `casestudy1-427906.tripdata.filtered_data`;
