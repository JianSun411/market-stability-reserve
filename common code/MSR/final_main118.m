clear;
load('small_118data_quantile.mat') %load dataset
p = 0.98; %choose the parameter: the system stability
carbon_allow = 3200;  %choose the parameter: the carbon allowance
MSR_list = [2800, 3000]; %choose the parameter: list of marker stability reserves
[social_cost, time_consume, x_records, iter_list, l_best_list] = MSR_model(n_thermal, n_wind, T, TLC, PTDF, ...,
min_p, max_p, ramp_down, ramp_up, g_0, fuel, r, u, w_min, w_max, demand, UCA, carbon_allow, gen_location, MSR_list, p);
[used_ca, used_msr, used_ce] = get_CE(x_records, n, n_wind, demand, n_thermal, UCA, T);
save('final_8_gen_CA_3200_MSR_2800_3000_2_p_0.98.mat', 'social_cost', 'time_consume', 'x_records', 'iter_list', 'l_best_list',...
    'MSR_list', 'used_ca', 'used_msr', 'used_ce')


