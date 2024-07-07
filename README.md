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
- Relevant SQL Query: [Combining Data]()
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
- Relevant SQL Query: [Data Cleaning]()
- After examining the '*combined_data*' table, we identified that `ride_id` serves as the primary key. We can proceed to verify that each `ride_id` has exactly 16 characters and ensure there are no duplicate entries.
  ```
  SELECT
  COUNT(*) - COUNT(ride_id) AS ride_id
  FROM `casestudy1-427906.tripdata.combined_data`
  ```
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/3f88ee86-77a3-4ab2-85b2-bb4d43f98829)
  
  ```
  SELECT COUNT(ride_id) AS ride_count
  FROM `casestudy1-427906.tripdata.combined_data`
  WHERE LENGTH(ride_id) != 16;
  ```
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/2b031a7c-b96d-43d2-8bf8-4ea8de4290ba)
  
  ```
  SELECT ride_id,
    COUNT(*) AS duplicate_ride_id
  FROM `casestudy1-427906.tripdata.combined_data`
  GROUP BY ride_id
  HAVING
    COUNT(*) > 1;
  ```
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/f11a3f83-db90-4f5d-b374-eecdc1df59f5)
  
- Next, we identify the number of NULL values in each of the remaining 12 colummns.
  
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/cf1ee0fe-d91f-4beb-b5b9-35322e7f58fb)

- Subsequently, we will manipulate the data by creatinging a new table '*filtered_data*' to include the following new columns: `ride_length`, `month`, `day_of_week`, and `hour_of_day`. We will remove all rows that contain NULL values in any of the initial 12 columns. Additionally, rows where `ride_length` exceeds 1440 minutes (more than 1 day) or is less than 1 minute will also be removed.
- Ensure that the `month`, `day_of_week`, and `hour_of_day` columns contain the correct number of distinct values: 12 for months, 7 for days of the week, and 24 for hours of the day, respectively.
  ```
  SELECT
    COUNT(DISTINCT month) AS no_of_months,
    COUNT(DISTINCT day_of_week) AS no_of_days,
    COUNT(DISTINCT hour_of_day) AS no_of_hours,
  FROM `casestudy1-427906.tripdata.filtered_data`;
  ```
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/7b2db149-deab-49d4-8979-6114b6e776c1)

- Ensure '*filtered_data*' has no NULL values in each of the 16 columns.

  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/598686bc-f163-4159-b5b7-7ceb5e79ac27)
  
## Analyze
### Data Analysis
- Relevant SQL Query: [Data Analysis]()
- Intresting data are queried to obtain necessary tables that highlights the differences in bike usages between 'casual' and 'member riders' for subsequent data visualisation.
  
- ## data Visualization
- Individual SQL tables are uploaded into Tableau for visualization and the resulting graphs proide isual insights to assist in analysis.
  
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/8f6e2b99-334b-44d3-bac9-9be547de5a7c)
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/878ca9c3-2228-4b21-ae1c-5ba4f9e57dae)
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/9438b3a3-8911-4882-8833-2531fd626014)
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/dfbd9209-5848-4b80-883e-773ea54b8def)
