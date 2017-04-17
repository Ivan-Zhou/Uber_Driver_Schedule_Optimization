%% This Mat file tests the effect of different max working hours on our IP Model
disp('Test: Effect of Max Number of Working Hours:');
% var_in_test = 'Regions'; % Set the name of variable to be tested on

%% Set Parameters
max_hour_list = 2:2:40; % Loop through different number of max hours per week
n_max_hours = size(max_hour_list,2); 
time_slot_available = ones(7,24); % Represent the timeslot when the driver is available
% Adjust the availble time
%time_slot_available(2,:) = 0;
%time_slot_available(4,:) = 0;
%time_slot_available(6:7,:) = 0;
%time_slot_available(:,1:18) = 0;

region_available = ones(1,5); % Initialize the vector that represent each region

avg_revenue_trip = 12; % Average Revenue the Driver get per trip
p_max = 1; % Maximum Probability that the Driver can get customers - best case scenario
p_min = 0.5; % Minimum Probability that the Driver can get customers - worse case scenario

%% Run the Test
count_out = 0; % Initialize the count of the outer loop
n_iters = 500; % Run multiple times to get a stable result
obj_iters = zeros(1,n_iters); % List to record the obj result in each iteration
time_iters = zeros(1,n_iters);% List to record the time result in each iteration
obj_list = zeros(1,n_max_hours); % Intialize the list to record the objective function
time_list = zeros(1,n_max_hours); % Intialize the list to record the objective function

cd .. % Direct to the outside folder
% Maximum number of hours a driver can work per week
for max_hours_per_week = max_hour_list
    count_in = 0; % Initialize the count of the inner loop
    for j = 1:n_iters
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
    
    disp(['Max Hour: ' num2str(max_hours_per_week) ' has finished']);
    
end

cd Test % Direct back to the original folder
cd Test_Result % Store the images in the Test Result

% plot the objective value
hold on
plot(max_hour_list,obj_list,'-r*');
legend('off');
grid

title('The Optimal Revenue Earned Per Week','fontsize',20)
xlabel('The Max Number of Hours (Per Week)','fontsize',20)
ylabel('The Optimal Revenue($)','fontsize',20)
hold off
saveas(gcf,'max_hours_obj.png');
close

% plot the Time
hold on
plot(max_hour_list,time_list,'-b*');
legend('off');
grid
set(gca,'fontsize',18)
title('The Computation Time','fontsize',20)
xlabel('The Max Number of Hours (Per Week)','fontsize',20)
ylabel('The (Average) Computation Time','fontsize',20)
hold off
saveas(gcf,'max_hours_time.png');
close

cd .. % Go back to the Test folder
