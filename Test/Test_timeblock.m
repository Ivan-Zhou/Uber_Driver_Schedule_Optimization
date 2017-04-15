%% This Mat file tests the effect of different number of available time block on the IP
disp('Test: Effect of Different Number of Available Time block:');

%% Set Parameters
max_hours_per_week = 8; % Maximum number of hours a driver can work per week
% Adjust the availble time
%time_slot_available(2,:) = 0;
%time_slot_available(4,:) = 0;
%time_slot_available(6:7,:) = 0;
%time_slot_available(:,1:18) = 0;

region_available = ones(1,5); % Initialize the vector that represent each region

slkt_weekday = 1:7; % Weekday to be chosen
slkt_hour = [0 1 7 8 16 17 18 19 20 21 22 23]+1; % Hours to be chosen
n_weekday = size(slkt_weekday,2);
n_hour = size(slkt_hour,2);

avg_revenue_trip = 12; % Average Revenue the Driver get per trip
p_max = 1; % Maximum Probability that the Driver can get customers - best case scenario
p_min = 0.5; % Minimum Probability that the Driver can get customers - worse case scenario

%% Run the Test
time_block_available = 2:2:n_weekday*n_hour;
n_test = size(time_block_available,2);
count_out = 0; % Initialize the count of the outer loop
n_iters = 400; % Run multiple times to get a stable result
obj_iters = zeros(1,n_iters); % List to record the obj result in each iteration
time_iters = zeros(1,n_iters);% List to record the time result in each iteration
obj_list = zeros(1,n_test); % Intialize the list to record the objective function
time_list = zeros(1,n_test); % Intialize the list to record the objective function

cd .. % Direct to the outside folder
for i = time_block_available
    count_in = 0; % Initialize the count of the inner loop
    for j = 1:n_iters
        time_slot_available = ones(7,24); % Reset Timeslots
        % Randomly select i elements in the region_available and set as 1
        perm_ind = randperm(n_weekday*n_hour);
        time_unavailable = find(perm_ind > i); % Get a fixed number of random selected indice to be marked as unavailable
        weekday_unavailable = slkt_weekday(floor((time_unavailable-1)/n_hour+1));
        hour_unavailable = slkt_hour(time_unavailable - n_hour*floor((time_unavailable-1)/n_hour));
        time_block_unavailable = (hour_unavailable-1).*n_weekday+weekday_unavailable;
        time_slot_available(time_block_unavailable) = 0; % Mark as unavailable
         
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
    
    disp(['Time Block: ' num2str(i) ' has finished']);
    
end

cd Test % Direct back to the original folder
cd Test_Result % Store the images in the Test Result

% plot the objective value
hold on
plot(time_block_available./2,obj_list,'-r*');
legend('Obj Value');

title('Objective Value Achieved with Different Number of Time Blocks')
xlabel('The Number of Available Time Blocks to be Selected')
ylabel('The Optimal Revenue Earned in 8 Hours($)')
grid
legend('show')
hold off
saveas(gcf,'timeblock_obj.png');
close

% plot the Time
hold on
plot(time_block_available./2,time_list,'-b*');
legend('Time');

title('Computation Time Costed with Different Number of Time Blocks')
xlabel('The Number of Available Time Blocks to be Selected')
ylabel('The (Average) Computation Time')
grid
legend('show')
hold off
saveas(gcf,'timeblock_time.png');
close

cd .. % Go back to the Test folder
