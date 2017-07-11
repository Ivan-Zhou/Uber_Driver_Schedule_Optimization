# Uber Driver Schedule Optimization
## Introduction
One of Uber’s key value propositions is offering scheduling flexibility to their driver-partners. According to a report by the Beneson Strategy Group, 73% of drivers prefer having a job that lets them choose their schedule. Drivers can use this flexibility to maximize their expected revenue during their available times. To this end, Uber provides heatmaps of customer demand that allow drivers to target high-demand regions that provide higher trip probability and therefore higher expected revenues. However, there is no readily available way to determine whether trips starting at a particular location are worth the time it would take to service the trip. For example, a trip that takes longer due to traffic but has high demand may result in fewer total trips and be less valuable. On the other hand trips with less demand but are consistently much faster may be more valuable. Therefore it is in the driver’s best interest to balance the demand of a location and the amount of time trips from that location will take. To address this gap, the team sought to create a scheduling optimization model, using Mixed Integer Programming (MIP).

<br>

## Data Collection
Two datasets were used to determine demand and trip duration. Because Uber demand data was not available, DC Taxicab pickup data was used as a proxy for demand. Duration was determined from an Uber Movement dataset.

### DC Taxicab Data
The dataset was sourced from Open Data DC. It describes individual taxicab trips from a specific location expressed in coordinates. From January to March, the dataset contains a total of 5,546,786 pickups at 10,843 different locations. In order to discretize the data and scope down the size of our problem, we needed to sort the pickups into high demand regions. First, the number of pickups at each location was counted. Then, to define the regions we selected the first 100 locations with the most pickup counts (see Figure x) as they cover 30% of the total number of pickups. MATLAB’s kmeans function was used to cluster the counts into 5 region centroids (see Figure x). The radius of each region was calculated based on the minimum Euclidean distance to the other four regions.

> Table: High-Demand REgion Parameters

|Region|Latitude|Longitude|Radius|
|---|---|---|---|
|0|38.9036460|-77.0520803|0.015496908|
|1|38.8978792|-77.0262628|0.012656732|
|2|38.9051074|-77.0366525|0.012656732|
|3|38.8933596|-77.0088673|0.017972991|
|4|38.9219662|-77.0471676|0.018967425|

> Figure x - 1: Taxicab Pickups in D.C.

![taxi_pickup_map](Resources/Screenshots/taxi_pickups_map.png) 

> Figure x - 2: High Demand Pickup Regions in D.C.

![taxi_pickup_region_map](Resources/Screenshots/taxi_pickups_regions_map.png)

<br>
Since we only compare the intra-region trips, pickup counts were then filtered to only include trips that originated from one of the five regions and whose destinations are within the same region as the origin. Counts were then averaged and aggregated across the time of day, day of week, and region. A sample of the cleaned, discretized dataset can be found below.

> Table: Sample of Demand Data used for Model

|Weekday|Hour|Region|Avg_Pickups|
|---|---|---|---|
|1|0|0|34.76923077|
|3|2|2|49.69230769|
|5|23|1|44.66666667|
|7|6|4|111.2307692|

### Uber Movement Data

> To be continued


