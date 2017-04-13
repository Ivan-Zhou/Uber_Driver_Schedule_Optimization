T = readtable('Data/DC_Cab_Pickup/Aggregated_Traffic_Demand_Season_1.csv');

[n,zz] = size(T);
coordinates = T;

coordinates.Year= [];
rankedcoordinates = coordinates;
ranked = sortrows(rankedcoordinates,3);
coordinates = ranked(end-101:end-1,:);
coordinates.CountObjectid = [];
coordinates = table2array(coordinates);



Z = linkage(coordinates,'complete','euclidean');
c = cluster(Z,'maxclust',3,'Depth',5);
set(0,'RecursionLimit', 100000);
%%figure()
%%dendrogram(Z,100,'ColorThreshold','default');
%%histogram(c);
%%hold on
%%hold off

[clK, Centroids] = kmeans(coordinates,5);
[he,~] = histcounts(clK);


%Compute distances from 1 point to the other 4
%Take the minimum distance and divide it by 2 to get radius

%Create 5x5 matrix
wrenchMatrix = ones(5);
loc1= Centroids(1,:);
loc2 = Centroids(2,:);
loc3 = Centroids(3,:);
loc4 = Centroids(4,:);
loc5 = Centroids(5,:);


%Calculate euclidian distance
d12 = sum((loc1-loc2).^2).^0.5;
d13 = sum((loc1-loc3).^2).^0.5;
d14 = sum((loc1-loc4).^2).^0.5;
d15 = sum((loc1-loc5).^2).^0.5;
wrenchMatrix(1,1:5) = [1 d12 d13 d14 d15];

d21 = sum((loc2-loc1).^2).^0.5;
d23 = sum((loc2-loc3).^2).^0.5;
d24 = sum((loc2-loc4).^2).^0.5;
d25 = sum((loc2-loc5).^2).^0.5;
wrenchMatrix(2,1:5) = [d21 1 d23 d24 d25];

d31 = sum((loc3-loc1).^2).^0.5;
d32 = sum((loc3-loc2).^2).^0.5;
d34 = sum((loc3-loc4).^2).^0.5;
d35 = sum((loc3-loc5).^2).^0.5;
wrenchMatrix(3,1:5) = [d31 d32 1 d34 d35];

d41 = sum((loc4-loc1).^2).^0.5;
d42 = sum((loc4-loc2).^2).^0.5;
d43 = sum((loc4-loc3).^2).^0.5;
d45 = sum((loc4-loc5).^2).^0.5;
wrenchMatrix(4,1:5) = [d41 d42 d43 1 d45];

d51 = sum((loc5-loc1).^2).^0.5;
d52 = sum((loc5-loc2).^2).^0.5;
d53 = sum((loc5-loc3).^2).^0.5;
d54 = sum((loc5-loc4).^2).^0.5;
wrenchMatrix(5,1:5) = [d51 d52 d53 d54 1];


wrench1 = min(wrenchMatrix(1,:));
wrench2 = min(wrenchMatrix(2,:));
wrench3 = min(wrenchMatrix(3,:));
wrench4 = min(wrenchMatrix(4,:));
wrench5 = min(wrenchMatrix(5,:));