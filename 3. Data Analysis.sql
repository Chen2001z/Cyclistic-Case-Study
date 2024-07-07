-- Distribution of rideable types
SELECT member_casual, rideable_type, COUNT(ride_id) AS no_of_trips
FROM `casestudy1-427906.tripdata.filtered_data`
GROUP BY member_casual, rideable_type
ORDER BY member_casual;

-- Number of trips monthly
SELECT member_casual, month, COUNT(ride_id) AS monthly_trips
FROM `casestudy1-427906.tripdata.filtered_data`
GROUP BY member_casual, month
ORDER BY member_casual;

-- Number of trips daily
SELECT member_casual, day_of_week, COUNT(ride_id) AS daily_trips
FROM `casestudy1-427906.tripdata.filtered_data`
GROUP BY member_casual, day_of_week
ORDER BY member_casual;

-- Number of trips hourly
SELECT member_casual, hour_of_day, COUNT(ride_id) AS hourly_trips
FROM `casestudy1-427906.tripdata.filtered_data`
GROUP BY member_casual, hour_of_day
ORDER BY member_casual, hour_of_day;

-- Average monthly ride duration
SELECT member_casual, month, AVG(ride_length) AS avg_monthly
FROM `casestudy1-427906.tripdata.filtered_data`
GROUP BY member_casual, month
ORDER BY member_casual;

-- Average daily ride duration
SELECT member_casual, day_of_week, AVG(ride_length) AS avg_daily
FROM `casestudy1-427906.tripdata.filtered_data`
GROUP BY member_casual, day_of_week
ORDER BY member_casual;

-- Average hourly ride duration
SELECT member_casual, hour_of_day, AVG(ride_length) AS avg_hourly
FROM `casestudy1-427906.tripdata.filtered_data`
GROUP BY member_casual, hour_of_day
ORDER BY member_casual, hour_of_day;

-- Starting locations
SELECT start_station_name, member_casual,
  AVG(start_lat) AS start_lat, AVG(start_lng) AS start_lng, 
FROM `casestudy1-427906.tripdata.filtered_data`
GROUP BY start_station_name, member_casual;

-- Ending locations
SELECT end_station_name, member_casual,
  AVG(end_lat) AS end_lat, AVG(end_lng) AS end_lng,
  COUNT(ride_id) AS total_trips
FROM `casestudy1-427906.tripdata.filtered_data`
GROUP BY end_station_name, member_casual;
