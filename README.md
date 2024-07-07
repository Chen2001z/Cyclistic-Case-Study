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

## Share
### Data Visualization And Insights
- Individual SQL tables are uploaded into Tableau for visualization and the resulting graphs proide isual insights to assist in analysis.
- When creating visualizations for '**Starting Trip Locations**', we noted that `Start_Lng` is of 'Number (decimal)' type, hence it is converted to 'Geographic - Longitude'.
  
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/43110d5b-c621-42d8-a14d-c4be6ca49fad)
    
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/48bf9403-fb47-42ad-841c-e8fbbe8ec0d2)

- Note that for all visualizations, casual riders are denoted with a lighter shade of brown compared to that of member riders.
  
  #### Distribution of Rideable Types
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/3d130b4a-6a23-4a9d-a962-01248af1c45d)

- **Observations**: Docked bikes are exclusively used by casual riders. Both casual and member riders prefer classic bikes over electric bikes. Member riders use both classic and electric bikes more frequently than casual riders, likely due to the higher number of member users. In fact, member riders accounted for approximately 64% of the total number of trips in 2023

  #### Number of Trips by Rider Type
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/878ca9c3-2228-4b21-ae1c-5ba4f9e57dae)
  
- **Observations**: Based on monthly, daily, and hourly trip counts, it's evident that member riders consistently use the service more frequently than casual riders.  
- **Monthly Trips**: Ridership increases from January to July/August, followed by a decline. Harsh winter conditions in January, February, and December likely discourage cycling, while summer holidays in July and August boost ridership.
- **Daily Trips**: Casual riders peak on weekends, whereas member ridership is highest midweek and lowest on weekends. Casual riders likely prefer cycling for recreational activities, while members use bikes for commuting to and from workplaces or schools.
- **Hourly Trips**: Casual ridership peaks around 5 pm, indicating a preference for daytime rides. Member riders peak between 6-8 am and 3-5 pm, suggesting use for commuting as it aligns with typical morning and afternoon peak travel times. 

  #### Average Trip Durations
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/9438b3a3-8911-4882-8833-2531fd626014)

- **Observations**: Casual riders have a longer ride duration compared to member riders.
- **Monthly**: Ride duration increases from January to July/August, then declines, likely to be influenced by weather conditions.
- **Daily**: Casual riders have longer ride durations, especially on weekends. This suggests leisurely rides, whereas member riders have shorter, more purpose-driven rides likely due to using it as a means of commuting.
- **Hourly**: Graph indicates a decrease in ride duration during early morning hours (3-5 am), and a significant peak in ride duration between 10 am - 2 pm for casual riders., while member riders maintain stable durations throughout the day.

  #### Trip Location
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/dfbd9209-5848-4b80-883e-773ea54b8def)
  
- **Casual Riders**: Typically start their bike trips at stations located near the harbor, coast, or rivers. This suggests that casual riders prefer starting their journeys at scenic locations and tourist attractions, reinforcing the idea that they use bike-sharing services primarily for leisure and exploration.
- **Member Riders**: Exhibit a more dispersed pattern of start locations, often concentrated in areas with high street density. These locations are likely near their residences, from which they commute to work, school, or other regular destinations. This distribution suggests that member riders use bike-sharing as a practical mode of transportation integrated into their daily routines.

## Act
### Conclusions
Analysis from the graphs reveals significant disparities in usage patterns, highlighting distinct differences in motivations and behaviors between casual and member riders. 
  
Casual riders exhibit an increased usage of bike-sharing during the weekends. Trip durations are also generally longer than that of member riders and starting locations are generally concentrated near scenic locations, hence suggesting a preference of bike-sharing for leisurely activities and recreational outings.
  
Member riders exhibit an increased ridership during the weekdays. Trip durations are also generally shorter than of casual riders. The clear peaks in ridership during morning and afternoon rush hours indicates that member riders rely on bike-sharing for daily transportation needs. Additionally the dispersed starting trip location, often near residential areas, reinforces the use of bike-sharing for commuting purposes.
  
These insights indicate that casual riders primarily use bike-sharing for leisure and exploration, while member riders rely on it for daily transportation needs.
