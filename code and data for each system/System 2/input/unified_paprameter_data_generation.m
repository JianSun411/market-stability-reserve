%%
data = loadcase('case118');
[n, ~] = size(data.gen);

% the parameter given by me
n_wind = 9; 
T = 3;
trans = eye(n);
aim = [6, 14, 20, 22, 25, 26, 39];
repalce = [47, 48, 49, 50, 52, 53, 54];
for i = linspace(1, 7, 7)
    trans(aim(i), aim(i)) = 0;
    trans(aim(i), repalce(i)) = 1;
    trans(repalce(i), repalce(i)) = 0;
    trans(repalce(i), aim(i)) = 1;
    sum(sum(trans))
end
% suppose the last generators have wind turbine.
load('C:\Users\22390\Desktop\accpm\8_generator_118_MSR\8_gen_other parameters.mat')
% 
% the parameters mainly from the example case
n_thermal = n - n_wind;
TLC = xlsread('C:\Users\22390\Desktop\IEEE118bus_data_figure.xls', 'Branch');
TLC = TLC(:, 10);
PTDF = makePTDF(data);
[n_line, n_bus] = size(PTDF);
max_p = data.gen(:, 9);
max_p = trans * max_p;
min_p = data.gen(:, 10);
min_p = trans * min_p;
g_0 = data.gen(:, 2);
g_0 = trans * g_0;
fuel = data.gencost(:, 5:6);
fuel = trans * fuel;
fuel = fuel';
gen_location = data.gen(:, 1);
gen_location = trans * gen_location;

E = zeros(n_bus, n);%turn the generator-based generation matrix x into
%bus-based generation matrix.
for i = 1:n
    E(gen_location(i), i) = 1;
end

cvx_begin quiet
    variables x(n, T)
    minimize sum(UCA * x)
    subject to
        sum(x) == sum(demand);
        PTDF * E * x - PTDF * demand<=repmat(TLC, 1, T);
        PTDF * E * x - PTDF * demand>=repmat(-TLC, 1, T);
        x<=repmat(max_p, 1, T);
        x>=repmat(min_p, 1, T);
        x(:, 1)-g_0<=ramp_up;
        x(:, 1)-g_0>=-ramp_down;
        for i = 1:n
            for j = 1: T-1
                x(i, j+1) - x(i, j)<=ramp_up(i);
                x(i, j+1) - x(i, j)>= - ramp_down(i);
            end
        end
cvx_end

profile = x;
tmpp = sum(profile, 2);
total_cost = fuel(1, :) * sum(profile.^2, 2) + fuel(2, :) * tmpp; %4.2471e5
as_CA = UCA(1:n_thermal) * tmpp(1:n_thermal); %8767.4
as_MSR = UCA(n_thermal + 1:end) * tmpp(n_thermal + 1:end); %1158.6

min_carbon_allow = cvx_optval;

%the wind distribution
load('118wind_quantile.mat');
u = uhat;
r = rhat;
w_max = maxhat;
w_min = minhat;
clear data x E i j cvx_cputime cvx_optbnd cvx_optval cvx_slvitr cvx_slvtol trans uhat rhat max_list min_list

save('final_9_gen_118data_quantile.mat')