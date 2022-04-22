clear;
load('final_118storage_data.mat') %load datasets 
p = 0.98; %choose the parameter: system stability
s_0 = 0.75 * s_0/max(s_0); %choose the parameter: initial SOC, 0.5 for low, 0.75 for medium and 1 for high.
B_list = [60]; % choose the parameter: list of storage capacity
[social_cost, time_consume, x_records, ~] = Sto_model(n_thermal, n_wind, T, TLC, PTDF, ...,
min_p, max_p, ramp_down, ramp_up, g_0, fuel, r, u, w_min, w_max, demand, gen_location, B_list, s_0, p);
save('final_9_original_gen_60_60_1_medium_p_0.98.mat', 'social_cost', 'time_consume', 'x_records', 'B_list')
