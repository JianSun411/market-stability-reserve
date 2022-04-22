function [social_cost, time_consume, x_records, iter_list, l_best_list] = MSR_model(n_thermal, n_wind, T, TLC, PTDF, ...,
min_p, max_p, ramp_down, ramp_up, g_0, fuel, r, u, w_min, w_max, demand, UCA, carbon_allow, gen_location, MSR_list, p)
%n_thermal: scaler, number of thermal generators
%n_wind: scalar, number of renewable generators
%T: number of time periods
%TLC: n_line * 1 vector, transmission line capacity
%PTDF: n_line * n_bus matrix, power transifer distribution factor
%min_p, max_p: n * 1 vectors, minimal/maximal generation 
%ramp_down, ramp_up: n * 1 vectors, minimal ramping down/up constraints
%fuel: 2 * n vector, the fuel cost of thermal generators and the equipped
%generators.
%g_0: n * 1 vector, the initial state of generators.
%r: n_wind * n_wind matrix, the covariance matrix of wind distribution
%u: n * 1 vector, exceptation of the wind distribution
%demand: n * T matrix, the demand of each bus at each time
%UCA: 1 * n vector, unit carbon emission 
%carbon_allow, MSR: scalars, carbon allowances and market stability reserve
%w_min/w_max: n * 1 vectors, TN(u, r, w_min, w_max) is the wind
%distribution.

%% parameter setting
N = n_thermal + 2 * n_wind - 1;
n = n_thermal+n_wind;
A = zeros(n_wind * T, N * T);
J = [zeros(n_wind, n_thermal - 1), -eye(n_wind), eye(n_wind)];
for i = 1: T
    row_start = (i - 1) * n_wind + 1;
    row_end = i * n_wind;
    column_start = (i - 1) * N + 1;
    column_end = i * N;
    A(row_start:row_end, column_start: column_end) = J;
end
n_decision = (n_thermal + 2* n_wind - 1) * T; 
niter = 5000; % maximal iterations 
thre = 1e-5; % threshold of accuracy
m = 10000; % number of samples

%% the system data loading 
[s_hugeC, s_highc, consD, bigD]  = data_form(n_thermal, n_wind, demand, T, TLC, PTDF, ...,
min_p, max_p, ramp_down, ramp_up, g_0, gen_location);

%(3.4)
D = [ones(1, n - 1), zeros(1, n_wind)];
temp = repmat([UCA(2:n_thermal), zeros(1, 2*n_wind)] - UCA(1) * D, 1, T);
tempC6 = temp;
tempc6 = [carbon_allow - UCA(1) * sum(consD)];

LM = length(MSR_list);
social_cost = zeros(1, LM);
x_records = zeros(n_decision, LM);
time_consume = zeros(1, LM);
iter_list = zeros(1, LM);
l_best_list = zeros(LM, niter);
for i = 1:LM
    i
    MSR = MSR_list(i);

    % (3.8)
    tempC7 = repmat([zeros(1, n-1), UCA(n_thermal+1: end)], 1, T);
    tempc7 = [MSR];
    hugeC = [s_hugeC; tempC6; tempC7];
    highc = [s_highc; tempc6; tempc7];

    %% the optimizer
    % notice that the distribution data is the distriburion of -wind.
    [x, iter, f_best, l_best, t, x_his, Pr_his, C_his, c_his, eps, flag] = myaccpm_drop(n_decision, fuel, hugeC, highc, A, p, r, -u, ...
        -w_max, -w_min, consD, bigD, n_thermal, n_wind, T, niter, m, thre);
    if flag(1) == 'w'
        social_cost(i) = 0;
    else
        social_cost(i) = min(f_best);
    end
    time_consume(i) = t;
    x_records(:, i) = x;
    iter_list(i) = iter;
    l_best_list(i, :) = l_best;
end
