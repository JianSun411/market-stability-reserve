data = loadcase('case6ww');

% the parameter given by me
n_wind = 1; 
trans = [0,1,0; 0,0,1;1,0,0]; %the last generator is equpped with a wind turbine, so all the data related to generators has to be translated.
T = 10;
ramp_down = [0.3; 0.15; 0.2] .* data.gen(:, 9);
ramp_down = trans * ramp_down;
ramp_up = ramp_down;
UCA = [2, 1, 0.5];
UCA = (trans * UCA')';

% the parameters mainly from the example case
[n, ~] = size(data.gen);
n_thermal = n - n_wind;
TLC = data.branch(:, 6);
PTDF = makePTDF(data);
[n_line, n_bus] = size(PTDF);
max_p = data.gen(:, 9);
max_p = trans * max_p;
min_p = data.gen(:, 10);
min_p = trans * min_p;
min_p(end) = 0;
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

min_carbon_allow = cvx_optval;

%the wind distribution
basic_u1 = 100;
temp = rand(T, 1) + 0.5;
u1 = temp * basic_u1;
temp = 10 * diag(rand(n_wind * T,1));
U = 3 * orth(rand(n_wind * T,n_wind * T));
r1 = U' * temp * U;
w_max1 = 2 * basic_u1;

basic_u2 = 150;
temp = rand(T, 1) + 0.5;
u2 = temp * basic_u2;
temp = 10 * diag(rand(n_wind * T,1));
U = 3 * orth(rand(n_wind * T,n_wind * T));
r2 = U' * temp * U;
w_max2 = 2 * basic_u2;

basic_u3 = 180;
temp = rand(T, 1) + 0.5;
u3 = temp * basic_u3;
temp = 10 * diag(rand(n_wind * T,1));
U = 3 * orth(rand(n_wind * T,n_wind * T));
r3 = U' * temp * U;
w_max3 = 2 * basic_u3;
clear temp U data x E i j x cvx_cputime cvx_optbnd cvx_optval cvx_slvitr cvx_slvtol trans

w_min = 0;

save('case6.mat')

