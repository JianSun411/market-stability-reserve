% %% get uhat and rhat
% 
% T = 3;
% area_list = {'PSCO', 'IPCO','LDWP', 'WACM', 'NEVP', 'MISO', 'ISNE','CISO'};
% n_wind = length(area_list);
% min_list = zeros(1, n_wind);
% max_list = zeros(1, n_wind);
% all_data = [];
% for indx = 1:length(area_list)
%     area = area_list{indx};
%     data = xlsread(['C:\Users\22390\Desktop\MSR\row wind data\', area, '_quantile.xlsx']);
%     data(data<0) = 0;
%     min_list(indx) = min(min(data));
%     max_list(indx) = max(max(data));
%     all_data = [all_data, data];
% end
% 
% min_list = repmat(min_list, T, 1);
% min_list = reshape(min_list, n_wind * T, 1);
% max_list = repmat(max_list, T, 1);
% max_list = reshape(max_list, n_wind * T, 1);
% area
% [uhat, rhat, minhat, maxhat]  = fit_trunc(all_data, min_list, max_list);
% save('small_118wind_quantile.mat', 'all_data', 'uhat', 'rhat', 'minhat', 'maxhat')

%%
data = loadcase('case118');
[n, ~] = size(data.gen);

% the parameter given by me
n_wind = 8; 
T = 3;
trans = eye(n);
aim = [30, 40, 37, 28, 29, 5, 12, 11];
repalce = linspace(47, 54, 8);
for i = linspace(1, 8, 8)
    trans(aim(i), aim(i)) = 0;
    trans(aim(i), repalce(i)) = 1;
    trans(repalce(i), repalce(i)) = 0;
    trans(repalce(i), aim(i)) = 1;
end
% suppose the last generators have wind turbine.
ramp_down = 0.5 * rand(n, 1) .* data.gen(:, 9);
ramp_down = trans * ramp_down;
ramp_up = ramp_down;
UCA = 2 * rand(1, n);
UCA = (trans * UCA')';
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
 
basic_demand = data.bus(:, 3);
demand = zeros(n_bus, T);
for i = 1:T
    temp = rand(n_bus, 1) - 0.5;
    temp = 0.5 * temp;
    temp = 1 + temp;
    demand(:, i) = basic_demand .* temp;  
end

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
total_cost = fuel(1, :) * sum(profile.^2, 2) + fuel(2, :) * tmpp; %4.4519e5
as_CA = UCA(1:n_thermal) * tmpp(1:n_thermal); %2.6174e3
as_MSR = UCA(n_thermal + 1:end) * tmpp(n_thermal + 1:end); %4.8501e3

min_carbon_allow = cvx_optval;

%the wind distribution
load('small_118wind_quantile.mat');
u = uhat;
r = rhat;
w_max = maxhat;
w_min = minhat;
clear data x E i j cvx_cputime cvx_optbnd cvx_optval cvx_slvitr cvx_slvtol trans uhat rhat max_list min_list

save('small_118data_quantile.mat')
