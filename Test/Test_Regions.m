%% This Mat file tests the effect of different number of Regions on our IP Model
disp('Test: Effect of Different Number of Regions in the IP Model:');
% var_in_test = 'Regions'; % Set the name of variable to be tested on

%% Set Parameters
max_hours_per_week = 8; % Maximum number of hours a driver can work per week
time_slot_available = ones(7,24); % Represent the timeslot when the driver is available
% Adjust the availble time
%time_slot_available(2,:) = 0;
%time_slot_available(4,:) = 0;
%time_slot_available(6:7,:) = 0;
%time_slot_available(:,1:18) = 0;

region_available = zeros(1,5); % Initialize the vector that represent each region

avg_revenue_trip = 12; % Average Revenue the Driver get per trip
p_max = 1; % Maximum Probability that the Driver can get customers - best case scenario
p_min = 0.5; % Minimum Probability that the Driver can get customers - worse case scenario

%% Run the Test
n_regions = 5; % Number of regions
region_loop = 1:n_regions;
count_out = 0; % Initialize the count of the outer loop
n_iters = 500; % Run multiple times to get a stable result
obj_iters = zeros(1,n_iters); % List to record the obj result in each iteration
time_iters = zeros(1,n_iters);% List to record the time result in each iteration
obj_list = zeros(1,n_regions); % Intialize the list to record the objective function
time_list = zeros(1,n_regions); % Intialize the list to record the objective function

cd .. % Direct to the outside folder
for i = region_loop
    count_in = 0; % Initialize the count of the inner loop
    for j = 1:n_iters
        % Randomly select i elements in the region_available and set as 1
        perm_ind = randperm(n_regions);
        region_available(perm_ind <= i) = 1; % Indicate which of the 5 regions the driver is avilable to go
        %% Launch the IP Solver
        % Record the objective value and time
        [~,obj_ip,time_ip] = Solve_IP(max_hours_per_week,time_slot_available,region_available,avg_revenue_trip,p_max,p_min);
        count_in = count_in+1;
        obj_iters(count_in) = obj_ip;
        time_iters(count_in) = time_ip;
    end
    % Record the result in the list
    
    count_out = count_out+1;
    obj_list(count_out) = mean(obj_iters);
    time_list(count_out) = mean(time_iters);
    
    disp(['Region: ' num2str(i) ' has finished']);
    
end

cd Test % Direct back to the original folder
cd Test_Result % Store the images in the Test Result

% plot the objective value
hold on
plot(region_loop,obj_list,'-r*');
legend('Obj Value');

title('Objective Value Achieved with Different Number of Regions')
xlabel('The Number of Regions to be Selected')
ylabel('The Optimal Revenue Earned in 8 Hours($)')
grid
legend('show')
hold off
saveas(gcf,'regions_obj.png');
close

% plot the Time
hold on
plot(region_loop,time_list,'-b*');
legend('Time');

title('Computation Time Costed with Different Number of Regions')
xlabel('The Number of Regions to be Selected')
ylabel('The (Average) Computation Time')
grid
legend('show')
hold off
saveas(gcf,'regions_time.png');
close

cd .. % Go back to the Test folder
