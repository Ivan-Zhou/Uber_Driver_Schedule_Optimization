function P_new_customer = Cvt_Traffic_Probability(Avg_Traffic,p_max,p_min)
%% This function converts traffic amount into probability of getting new customers
% We assume the Avg_Traffic has uniform distribution 
% Avg_Traffic: a vertical vector of different traffic amount
% p_max: maximum probability that the driver can get new customers - best
% case scenario
% p_min: minimum probability that the driver can get new customers - worse
% case scenario

max_traffic = max(Avg_Traffic);
min_traffic = min(Avg_Traffic);

multiplier = (p_max-p_min)/(max_traffic-min_traffic);

P_new_customer = p_min+ multiplier.*(Avg_Traffic-min_traffic);