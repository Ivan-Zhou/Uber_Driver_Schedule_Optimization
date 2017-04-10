%% Set Parameters
max_hours_per_week = 8; % Maximum number of hours a driver can work per week
time_slot_available = ones(7,24); % Represent the timeslot when the driver is available
% Adjust the availble time
%time_slot_available(2,:) = 0;
%time_slot_available(4,:) = 0;
%time_slot_available(6:7,:) = 0;
%time_slot_available(:,1:18) = 0;

region_avilable = ones(5,1); % Indicate which of the 5 regions the driver is avilable to go


%% Adjust Weight Multiplier
weight_var_multiplier = 1;
weight_demand_multiplier = 1;

%% Launch the IP Solver
[x] = Solve_IP(max_hours_per_week,time_slot_available,region_avilable,weight_var_multiplier,weight_demand_multiplier);