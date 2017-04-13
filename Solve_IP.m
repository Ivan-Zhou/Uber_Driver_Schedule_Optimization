function [x] = Solve_IP(max_hours_per_week,time_slot_available,region_avilable,avg_revenue_trip,p_max,p_min)
%% This function solve the IP Model of Uber Driver Scheduling Problem
% max_hours_per_week: Maximum number of hours the driver can contribute per
% week
% time_slot_available: a 7*24 matrix to indicate the driver's availablility
% in each hour of a week. 1 indicates available and 0 indicates not
% Region_available: a 1*5 vector indicates which region the driver likes
% to drive in; 1 indicates like and 0 indicates dislike
% weight_var_multiplier: multiplier used to adjust the weight of variability
% weight_demand_multiplier: multiplier used to adjust the weight of demand

%% Import Data
% Right click on the "Data_Demand_Variability.csv", select "Import Data"
T = readtable('Data/Processed_Data/Data_Demand_Variability.csv');
% Get Column Names
% T.Properties.VariableNames

% Store each column as a varaible
Weekday = T.Weekday;
Timeslot = T.Timeslot;
%AverageVariability = T.AverageVariability;
Max_Duration = T.AverageMax;
Avg_Traffic = T.Avg_Traffic;
Region = T.Region;

%% Convert Traffic into Probability of Getting new Customers
% P_new_customer is a vertical vector of the same size with Avg_Traffic
P_new_customer = Cvt_Traffic_Probability(Avg_Traffic,p_max,p_min);

%% Convert Max_Duration to Minimum Trips per Hour
% Max_Duration is the average Max Duration of Trips within that region &
% time slot. It is recorded on second. 
% The timeslots are at the unit of 2 hours
Min_Trips = 7200./Max_Duration;

%% Adjust the data based on the given parameters - driver's preference
weekday_choices = 1:7;
time_choices = [0 1 7 8 16 17 18 19 20 21 22 23];
timeslot_choices = [0 1 2 3 4 5]; % Timeslots that cooresponds to the above time_choices
n_weekdays_choices = size(weekday_choices,2);
n_timeslot_choices = size(weekday_choices,2);

% Initialize indices of element to be removed: all are 0 in the beginning
indices_to_be_rm = zeros(size(Weekday));
for d = weekday_choices
    for t = time_choices
        if time_slot_available(d,t+1) == 0 % Mark as in-available
           % Find the timeslot and weekday that cooresponding to that hour
           t_ind = find(time_choices==t);
           if mod(t_ind,2) == 0
               timeslot_to_be_rm = timeslot_choices(floor(find(time_choices==t)/2));
           else
               timeslot_to_be_rm = timeslot_choices(floor(find(time_choices==t)/2)+1);
           end
           weekday_to_be_rm = d;
           % Mark the indices of the elements to be removed
           indices_to_be_rm(Weekday == weekday_to_be_rm & Timeslot == timeslot_to_be_rm) = 1;
        end
    end
end

% Mark unavailable reigons
% We need to add 1 to the index of region
if sum(region_avilable)<5
    indices_to_be_rm(Region == find(region_avilable==0)-1) = 1;
end

% Removed all marked instances
% We need to backwards
if sum(indices_to_be_rm) >0
    ind_to_be_removed = find(indices_to_be_rm == 1);
    for i = sum(indices_to_be_rm):-1:1
        ind = ind_to_be_removed(i);
        Weekday(ind) = [];
        Timeslot(ind) = [];
        Min_Trips(ind) = [];
        P_new_customer(ind) = [];
        Region(ind) = [];
    end
end

% Number of variables
n_x = size(Min_Trips,1);
%% Formulate the IP
%  A vector of cost coefficients
% Probability of Getting new Customer * Average Trips/Hour
f = transpose(P_new_customer.*Min_Trips).*avg_revenue_trip;
% Integer Variables
intcon = 1:n_x;

% Constraint 1: Maximum number of hours per week
A1 = ones(1,n_x); % Lhs
b1 = max_hours_per_week/2;  % rhs

% Constraint 2: You cannot be in 2 regions during the same time
% Initialize A2 and b2
A2 = zeros(n_weekdays_choices*n_timeslot_choices,n_x);
b2 = ones(n_weekdays_choices*n_timeslot_choices,1); % Upper limit should be 1

row_count = 0;
for d = weekday_choices
    for t = timeslot_choices
        row_count = row_count+1;
        ind_marked = (Weekday == d & Timeslot == t);
        A2(row_count,ind_marked) =1;
    end
end
    
A = [A1;A2];
b = [b1;b2];
lb = zeros(n_x,1); 
ub = ones(n_x,1);
[x,fval] = intlinprog(-f,intcon,A,b,[],[],lb,ub);

%% Present the Solution
select_list = find(x==1);

% Set a basis for the weekday
day_number_benchmark = datetime(2017,04,9);

% Set a list of our pre-defined timeslot
timeslots = {'12AM - 2AM'; '7AM - 9AM'; '4PM - 6PM'; '6PM-8PM'; '8PM-10PM'; '10PM-12AM'};

for i = 1:sum(x)
    select_time = Timeslot(select_list(i));
    select_day = Weekday(select_list(i));
    select_region = Region(select_list(i));
    
    weekday_name = day(day_number_benchmark+select_day,'name');
    timeslot = timeslots(select_time +1);
    string_output = ['Recommendation ' num2str(i) ': Region ' num2str(select_region) ', ' timeslot ', ' weekday_name];
    
    %p_new = P_new_customer(select_list(i));
    %min_trip = Min_Trips(select_list(i));
    %string_output = ['Recommendation ' num2str(i) ': Region ' num2str(select_region) ', ' timeslot ', ' weekday_name ', ' p_new  ', ' min_trip];
    disp(string_output)
end

string_output = ['Total Revenue Earned: ' num2str(-1*fval)];
disp(string_output)