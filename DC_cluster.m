T = readtable('DC_Cab_Pickup/Aggregated_Traffic_Demand_Season_1.csv');

[n,zz] = size(T);
coordinates = T;

coordinates.Year= [];
coordinates.CountObjectid = [];
coordinates = table2array(coordinates);

Z = linkage(coordinates,'complete','euclidean');
Z(3,:)