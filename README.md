# Cyclistic-Case-Study

## Table of Contents
1. [Introduction]
2. [Ask]
3. [Prepare]
4. [Process]
5. [Analyze]
6. [Share]
7. [Act]

## Introduction
Cylistic, a bike-share company in Chicago, operates a network of over 5800 bicycles and 600 docking stations. The marketing analyst team at Cyclistic is focused on increasing the number of annual memberships, which is seen as crucial for the company's future success.

To achieve this goal, the team aims to understand the usage patterns of casual riders compared to annual members. By analyzing these differences, the team will develop a targeted marketing strategy to convert casual riders into annual members. The insights and recommendations will be presented to Cyclistic executives, supported by compelling data visualizations and professional data insights, to secure approval and drive the company's growth.

## Ask
### Deliverables
1. A clear statement of the business task
2. A description of all data sources used
3. Documentation of any cleaning or manipulation of data
4. A summary of your analysis
5. Supporting visualizations and key findings
6. Your top three recommendations based on your analysis

### Business Task
- Design marketing strategies aimed at converting casual riders into annual members.
- I have been assigned the following question to answer, which will guide the future marketing program: **How do annual members and casual riders use Cyclistic bikes differently?**

## Prepare
### Data Sources
Cyclistic's historical trip data, specifically covering the period from January 2023 to December 2023, will be used for this analysis. The trip data has been obtained from [divvy_tripdata](https://divvy-tripdata.s3.amazonaws.com/index.html). The data has been made available by Motivate International Inc. under this [license](https://www.divvybikes.com/data-license-agreement).

_This is public data that you can use to explore how different customer types are using Cyclistic bikes. But note that data-privacy issues prohibit you from using riders’ personally identifiable information. This means that you won’t be able to connect pass purchases to credit card numbers to determine if casual riders live in the Cyclistic service area or if they have purchased multiple single passes._

### Data Preparation
- CSV trip data from Jan 2023 to Dec 2023 ('202301-divvy-tripdata.zip' - '202312-divvy-tripdata.zip') are downloaded from the [link above](https://divvy-tripdata.s3.amazonaws.com/index.html) and uploaded to Google Cloud Storage.
- Files are then imported into Google BigQuery for data processing and cleaning using SQL.
> [!NOTE]
> This set of files cannot be directly uploaded to Google BigQuery tables because the files exceed the 100MB size limit.

## Process
### Combining Data
- Relevent SQL Query: [Combining Data]()
- After thoroughly examining each individual table's schema to ensure consistent data types, all 12 tables were successfully combined into a single consolidated table named '*combined_data*'.

  |Field name|Type|Mode|
  |----------|----|----|
  |ride_id|STRING|NULLABLE|
  |rideable_type|STRING|NULLABLE|
  |started_at|TIMESTAMP|NULLABLE|
  |ended_at|TIMESTAMP|NULLABLE|
  |start_station_name|STRING|NULLABLE|
  |start_station_id|STRING|NULLABLE|
  |end_station_name|STRING|NULLABLE|
  |end_station_id|STRING|NULLABLE|
  |start_lat|FLOAT|NULLABLE|
  |stat_lng|FLOAT|NULLABLE|
  |end_lat|FLOAT|NULLABLE|
  |end_lng|FLOAT|NULLABLE|
  |member_casual|STRING|NULLABLE|

### Data Cleaning
- Relevent SQL Query: [Data Cleaning]()
- After examining the '*combined_data*' table, we identified that `ride_id` serves as the primary key. We can proceed to verify that each `ride_id` has exactly 16 characters and ensure there are no duplicate entries.
  ```
  SELECT COUNT(ride_id) AS ride_count
  FROM `casestudy1-427906.tripdata.combined_data`
  WHERE LENGTH(ride_id) != 16;
  ```
  Result: 0
  
  ```
  SELECT ride_id,
    COUNT(*) AS duplicate_ride_id
  FROM `casestudy1-427906.tripdata.combined_data`
  GROUP BY ride_id
  HAVING
    COUNT(*) > 1;
  ```
  No result
- Next, we identify the number of NULL values in each of the remaining 12 colummns.
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/2e5bb4a9-eef3-40b9-8e6e-b7c82c1eea2b)
