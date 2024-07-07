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
- Note that for all visualizations, casual riders are denoted with a lighter shade of brown compared to that of member riders.
- When creating visualizations for '**Starting Trip Locations**', we noted that `Start_Lng` is of 'Number (decimal)' type, hence it is converted to 'Geographic - Longitude'
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/43110d5b-c621-42d8-a14d-c4be6ca49fad)
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/48bf9403-fb47-42ad-841c-e8fbbe8ec0d2)
  
  #### Rideable Types
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/3d130b4a-6a23-4a9d-a962-01248af1c45d)

- First, we analyze the distribution of rideable types - classic bikes, docked bikes, and electric bikes, based on rider types: casual and member riders.
- Notably, docked bikes are exclusively used by casual riders. Both casual and member riders prefer classic bikes over electric bikes. Member riders use both classic and electric bikes more frequently than casual riders, likely due to the higher number of member users. In fact, member riders accounted for approximately 64% of the total number of trips in 2023.

  #### Trip Counts
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/878ca9c3-2228-4b21-ae1c-5ba4f9e57dae)

- Secondly, we analyze the number of trips taken by casual and member riders. Based on monthly, weekly, and hourly trip counts, it's evident that member riders consistently use the service more frequently than casual riders.
  
- From the '**Monthly Trips**' graph, we observe a steady rise in ridership from January to July/August, followed by a notable decline. Potential reasons include:
  - Harsh winter conditions in January/February and December likely discourage cycling, with ridership increasing as temperatures warm up from March onward.
  - Peak ridership in July and August among both casual and member riders may be attributed to summer holidays.
    
- From the '**Daily Trips**' graph, we observed that casual riders peak on weekends, with a noticeable decrease during weekdays. Conversely, member ridership is highest midweek and lowest on weekends. Possibilities includes:
  - Casual riders' preference for cycling as part of recreational activities or outings.
  - Members primarily use bikes for commuting to and from workplaces or schools, aligning with typical weekday travel patterns.
  
- Analyzing the graph for '**Hourly Trips**', we observe distinct patterns for both casual and member riders:
  - Casual ridership shows a gradual increase from 5 am onwards, peaking at around 5 pm, followed by a sharp decline. This pattern suggests that casual riders prefer cycling during daytime hours, possibly for recreational activities or leisurely outings.
  - In contrast, member riders exhibit a different trend with pronounced peaks between 6 am to 8 am and 3 pm to 5 pm. This pattern indicates that members predominantly use bike-sharing for commuting purposes, aligning with typical morning and afternoon peak travel times.
    
- Analysis from the three graphs reveals significant disparities in usage patterns, highlighting distinct differences in motivations and behaviors between casual and member riders. Casual riders exhibit a consistent use of bike-sharing throughout the day, suggesting a preference for leisurely activities. In contrast, member riders show clear peaks during morning and afternoon rush hours, indicating a reliance on bike-sharing for daily transportation needs.

  #### Average Trip Durations
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/9438b3a3-8911-4882-8833-2531fd626014)

- Next, we analyze the average ride durations. Generally, member riders have a longer ride duration per month and per hour of day, whereas casual riders have a longer ride duration per day of week.

- From the ‘**Average Monthly Trip Duration**’ graph, we observe a similar pattern as the graph of ‘Number of Trips Per Month’, where there is generally a steady increase in average ride duration from January to July/August, followed by a decline.
  - This trend is likely influenced by weather and temperature, as favorable conditions from March onwards encourage longer rides, while extreme cold in January, February, and December limits outdoor activities and cycling duration. This trend is likely influenced by weather and temperature, as favorable conditions from March onwards encourage longer rides, while extreme cold in January, February, and December limits outdoor activities and cycling duration.

- The ‘**Average Daily Trip Duration**’ graph revealed that casual riders consistently have a longer ride duration per day of a week compared to member riders. Additionally, both rider types have longer ride duration during the weekends compared to weekdays. Such an observation could be due to:
  - **Purpose of riding**: Casual riders might be using the bikes for leisure and recreational activities, which are unhurried and enjoyable, hence leading to longer ride durations when they explore parks and city attractions. Member riders likely primarily use bikes for the purposes of commuting to work or school, hence their rides are more likely to be direct and time-sensitive, leading to a shorter average trip duration.
  - **Weekends vs weekdays**: During the weekends, both rider types have more free time, allowing for longer and more leisurely rides. Contrastingly, on weekdays, member riders’ primary use of bike-sharing is for commuting purposes, and casual riders may also have work or other obligations, hence resulting in shorter trip duration.

- An analysis of the ‘**Average Hourly Trip Duration**’ graph shows a decrease in ride duration during early morning hours (3-5 am), and a significant peak in ride duration between 10 am and 2 pm for casual riders. Member riders on the other hand, maintained a relatively stable average ride duration throughout the day. Possibilities include:
  - Casual riders tend to take longer, more leisure rides during late morning/early afternoon hours, likely for recreational purposes.
  - Member riders have a more consistent riding habit, likely due to using the bike-sharing service for commuting and other regular routine activities.

  #### Trip Location
  ![](https://github.com/Chen2001z/Cyclistic-Case-Study/assets/170075287/dfbd9209-5848-4b80-883e-773ea54b8def)

- Finally, the '**Starting Trip Locations**' analysis reveals distinct patterns for casual and member riders, aligning with their respective usage behaviors as mentioned above.
  - **Casual Riders**: typically start their bike trips at stations located near the harbor, coast, or rivers. This suggests that casual riders prefer starting their journeys at scenic locations and tourist attractions, reinforcing the idea that they use bike-sharing services primarily for leisure and exploration.
  - **Member Riders**: exhibit a more dispersed pattern of start locations, often concentrated in areas with high street density. These locations are likely near their residences, from which they commute to work, school, or other regular destinations. This distribution suggests that member riders use bike-sharing as a practical mode of transportation integrated into their daily routines.
