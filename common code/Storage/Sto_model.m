function [social_cost, time_consume, x_records, flag] = Sto_model(n_thermal, n_wind, T, TLC, PTDF, ...,
min_p, max_p, ramp_down, ramp_up, g_0, fuel, r, u, w_min, w_max, demand, gen_location, B_list, s_0, p)
%n_thermal: scaler, number of thermal generators
%n_wind: scalar, number of renewable generators
%T: number of time periods
%TLC: n_line * 1 vector, transmission line capacity
%PTDF: n_line * n_bus matrix, power transifer distribution factor
%min_p, max_p: n * 1 vectors, minimal/maximal generation 
%ramp_down, ramp_up: n * 1 vectors, minimal ramping down/up constraints
%fuel: 2 * n vector, the fuel cost of thermal generators and the storage (0)
%g_0: n_thermal * 1 vector, the initial state of generators.
%s_0: n_wind * 1 vector, the initial state of storages.
%r: n_wind * n_wind matrix, the covariance matrix of wind distribution
%u: n * 1 vector, exceptation of the wind distribution
%demand: n * T matrix, the demand of each bus at each time
%w_min/w_max: n * 1 vectors, TN(u, r, w_min, w_max) is the wind
%distribution.

%% parameter setting
N = n_thermal + 2 * n_wind - 1;
n = n_thermal+n_wind;
A = zeros(n_wind * T, N * T);
J = [zeros(n_wind, n_thermal - 1), -eye(n_wind), -eye(n_wind)];
for i = 1: T
    row_start = (i - 1) * n_wind + 1;
    row_end = i * n_wind;
    column_start = (i - 1) * N + 1;
    column_end = i * N;
    A(row_start:row_end, column_start: column_end) = J;
end
n_decision = (n_thermal + 2* n_wind - 1) * T; 
niter = 500; % maximal iterations 
thre = 1e-5; % threshold of accuracy
m = 10000; % number of samples

%% the system data loading 
[s_hugeC, s_highc, consD, bigD]  = Sto_data_form(n_thermal, n_wind, demand, T, TLC, PTDF, ...,
min_p, max_p, ramp_down, ramp_up, g_0, gen_location);

LB = length(B_list);
social_cost = zeros(1, LB);
time_consume = zeros(1, LB);
x_records = zeros(n_decision, LB);
for i = 1:LB
    i
    B = B_list(i);
    new_s_0 = B * s_0;

    % (4.1)
    J = [zeros(n_wind, n_thermal+n_wind-1), eye(n_wind)];
    tempC1 = zeros(2 * n_wind * T, N * T);
    for k = 1:T
        row_start = (k-1)*n_wind + 1;
        row_end = k * n_wind;
        for j = 1:k
            column_start = (j-1)*N+1;
            column_end = column_start + N - 1;
            tempC1(row_start:row_end, column_start:column_end) = [J];
        end
        row_start = row_start + n_wind * T;
        row_end = row_end + n_wind * T;
        for j = 1:k 
             column_start = (j-1)*N+1;
             column_end = column_start + N - 1;
             tempC1(row_start:row_end, column_start:column_end) = [-J];
        end
    end
    tempc1 = [repmat(B * ones(n_wind, 1) - new_s_0, T, 1); repmat(new_s_0, T, 1)];

    hugeC = [s_hugeC; tempC1];
    highc = [s_highc; tempc1];

    %% the optimizer
    % notice that the distribution data is the distriburion of -wind.
    [x, iter, f_best, l_best, t, x_his, Pr_his, C_his, c_his, eps, flag] = myaccpm_drop(n_decision, fuel, hugeC, highc, A, p, r, -u, ...,
        -w_max, -w_min, consD, bigD, n_thermal, n_wind, T, niter, m, thre);
    if flag(1) == 'w'
        social_cost(i) = 0;
    else
        social_cost(i) = min(f_best);
    end
    time_consume(i) = t;
    x_records(:, i) = x;
end
