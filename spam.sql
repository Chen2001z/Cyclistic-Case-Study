-- since ride_id is the primary key, we can check if to ensure that all ride_id has 16 characters and there are no duplicate ride_id

SELECT COUNT(ride_id) AS ride_count
FROM `casestudy1-427906.tripdata.combined_data`
WHERE LENGTH(ride_id) != 16;
-- result 0

SELECT ride_id,
  COUNT(*) AS duplicate_ride_id
FROM `casestudy1-427906.tripdata.combined_data`
GROUP BY ride_id
HAVING
  COUNT(*) > 1;
-- no result

-- identify the number of null values in each columns

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
FROM `casestudy1-427906.tripdata.combined_data`;
ss

-- data cleaning and adding new columns
CREATE OR REPLACE TABLE `casestudy1-427906.tripdata.filtered_data` AS -- create a new table titled 'filtered_data'
SELECT *,
       TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS ride_length, -- new column tiltled 'ride_length' 
       FORMAT_TIMESTAMP('%b', started_at) AS month, -- new column tiltled 'month' 
       FORMAT_TIMESTAMP('%a', started_at) AS day_of_week, -- new column tiltled 'day_of_week' 
       EXTRACT(HOUR FROM started_at) AS hour_of_day, -- new column tiltled 'hour_of_day'
FROM `casestudy1-427906.tripdata.combined_data`
WHERE rideable_type IS NOT NULL  -- remove rows with NULL values
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
  AND TIMESTAMP_DIFF(ended_at, started_at, MINUTE) <= 1440  -- remove rows where 'ride_length' is not more than a day or less than one minute
  AND TIMESTAMP_DIFF(ended_at, started_at, MINUTE) >= 1;

-- note that TIMESTAMP_DIFF and FORMAT_TIMESTAMP are functions specific to Google BigQuery


-- ensure the number of months/days/hours is correct
SELECT
  COUNT(DISTINCT month) AS no_of_months,
  COUNT(DISTINCT day_of_week) AS day_of_week,
  COUNT(DISTINCT hour_of_day) AS no_of_hours,
FROM `casestudy1-427906.tripdata.filtered_data`;
ss

-- ensure no null values in each column
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
  COUNT(ride_id) - COUNT(ride_length) AS ride_length,
  COUNT(ride_id) - COUNT(month) AS month,
  COUNT(ride_id) - COUNT(day_of_week) AS day_of_week,
  COUNT(ride_id) - COUNT(hour_of_day) AS hour_of_day,
FROM `casestudy1-427906.tripdata.filtered_data`;
ss


-- data analysis

-- rideable_type
SELECT member_casual, rideable_type, COUNT(ride_id) AS no_of_trips
FROM `casestudy1-427906.tripdata.filtered_data`
GROUP BY member_casual, rideable_type
ORDER BY member_casual;

-- number of trips monthly
SELECT member_casual, month, COUNT(ride_id) AS monthly_trips
FROM `casestudy1-427906.tripdata.filtered_data`
GROUP BY member_casual, month
ORDER BY member_casual;

-- number of trips daily
SELECT member_casual, day_of_week, COUNT(ride_id) AS daily_trips
FROM `casestudy1-427906.tripdata.filtered_data`
GROUP BY member_casual, day_of_week
ORDER BY member_casual;

-- number of trips hourly
SELECT member_casual, hour_of_day, COUNT(ride_id) AS hourly_trips
FROM `casestudy1-427906.tripdata.filtered_data`
GROUP BY member_casual, hour_of_day
ORDER BY member_casual, hour_of_day;

-- average ride duration monthly
SELECT member_casual, month, AVG(ride_length) AS avg_monthly
FROM `casestudy1-427906.tripdata.filtered_data`
GROUP BY member_casual, month
ORDER BY member_casual;

-- average ride duration daily
SELECT member_casual, day_of_week, AVG(ride_length) AS avg_daily
FROM `casestudy1-427906.tripdata.filtered_data`
GROUP BY member_casual, day_of_week
ORDER BY member_casual;

-- average ride duration hourly
SELECT member_casual, hour_of_day, AVG(ride_length) AS avg_hourly
FROM `casestudy1-427906.tripdata.filtered_data`
GROUP BY member_casual, hour_of_day
ORDER BY member_casual, hour_of_day;

-- starting locations
SELECT start_station_name, member_casual,
  AVG(start_lat) AS start_lat, AVG(start_lng) AS start_lng, -- despite having same station names, they have slightly different start_lat and start_lng, hence use AVG
  COUNT(ride_id) AS total_trips
FROM `casestudy1-427906.tripdata.filtered_data`
GROUP BY start_station_name, member_casual;

-- ending location
SELECT end_station_name, member_casual,
  AVG(end_lat) AS end_lat, AVG(end_lng) AS end_lng, -- -- despite having same station names, they have slightly different end_lat and end_lng, hence use AVG
  COUNT(ride_id) AS total_trips
FROM `casestudy1-427906.tripdata.filtered_data`
GROUP BY end_station_name, member_casual;
