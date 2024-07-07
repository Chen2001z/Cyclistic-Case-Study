b-- Combining Data

CREATE TABLE `casestudy1-427906.tripdata.combined_data` AS
SELECT *
FROM `casestudy1-427906.tripdata.202301`
UNION ALL
SELECT *
FROM `casestudy1-427906.tripdata.202302`
UNION ALL
SELECT *
FROM `casestudy1-427906.tripdata.202303`
UNION ALL
SELECT *
FROM `casestudy1-427906.tripdata.202304`
UNION ALL
SELECT *
FROM `casestudy1-427906.tripdata.202305`
UNION ALL
SELECT *
FROM `casestudy1-427906.tripdata.202306`
UNION ALL
SELECT *
FROM `casestudy1-427906.tripdata.202307`
UNION ALL
SELECT *
FROM `casestudy1-427906.tripdata.202308`
UNION ALL
SELECT *
FROM `casestudy1-427906.tripdata.202309`
UNION ALL
SELECT *
FROM `casestudy1-427906.tripdata.202310`
UNION ALL
SELECT *
FROM `casestudy1-427906.tripdata.202311`
UNION ALL
SELECT *
FROM `casestudy1-427906.tripdata.202312`
