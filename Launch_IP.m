%% Set Parameters
max_hours_per_week = 8; % Maximum number of hours a driver can work per week
time_slot_available = ones(7,24); % Represent the timeslot when the driver is available
% Adjust the availble time
%time_slot_available(2,:) = 0;
%time_slot_available(4,:) = 0;
%time_slot_available(6:7,:) = 0;
%time_slot_available(:,1:18) = 0;

region_avilable = ones(5,1); % Indicate which of the 5 regions the driver is avilable to go

avg_revenue_trip = 12; % Average Revenue the Driver get per trip
p_max = 1; % Maximum Probability that the Driver can get customers - best case scenario
p_min = 0.5; % Minimum Probability that the Driver can get customers - worse case scenario


%% Launch the IP Solver
[x] = Solve_IP(max_hours_per_week,time_slot_available,region_avilable,avg_revenue_trip,p_max,p_min);