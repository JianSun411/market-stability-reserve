load('data1.mat')
[uhat, rhat] = nihe(data);

load('case6.mat')
w_max = repmat(max(max(data)), T, 1);
w_min = repmat(min(min(data)), T, 1);
MSR_list = linspace(0, 200, 21);

carbon_allow = 740;
[social_cost, time_consume] = MSR_model(n_thermal, n_wind, T, TLC, PTDF, ...,
min_p, max_p, ramp_down, ramp_up, g_0, fuel, rhat, uhat, w_min, w_max, demand, UCA, carbon_allow, gen_location, MSR_list);
save('simulation740.mat', 'social_cost', 'time_consume')

carbon_allow = 770;
[social_cost, time_consume] = MSR_model(n_thermal, n_wind, T, TLC, PTDF, ...,
min_p, max_p, ramp_down, ramp_up, g_0, fuel, rhat, uhat, w_min, w_max, demand, UCA, carbon_allow, gen_location, MSR_list);
save('simulation770.mat', 'social_cost', 'time_consume')

carbon_allow = 800;
[social_cost, time_consume] = MSR_model(n_thermal, n_wind, T, TLC, PTDF, ...,
min_p, max_p, ramp_down, ramp_up, g_0, fuel, rhat, uhat, w_min, w_max, demand, UCA, carbon_allow, gen_location, MSR_list);
save('simulation800.mat', 'social_cost', 'time_consume')