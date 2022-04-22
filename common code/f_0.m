function [cost, g] = f_0(fuel, x, consD, D, n_thermal, n_wind, T)
% x is a (n_thermal + 2 * n_wind - 1) * T vector, indicating the dispatch
% profile.
%fuel_cost is a 2 * (n_thermal + n_wind) vector indicating the quatic fuel cost of
%generators.
%cost is the total fuel cost of dispatch profile x
%g is a 1 * [(n_thermal + 2 * n_wind - 1) * T] vector, the derivative of total fuel cost on x
N = n_thermal + 2 * n_wind - 1;
the_profile = reshape(x, [N, T]);
x1 = consD - D * the_profile;
the_profile = [x1; the_profile];
the_profile = [the_profile(1:n_thermal, :); the_profile(n_thermal+n_wind+1:end, :)];
cost = fuel(1, :) * sum(the_profile.^2, 2) + fuel(2, :) * sum(the_profile, 2);


temp1 = [fuel(1, 2:n_thermal), zeros(1, n_wind), fuel(1, (n_thermal + 1):end)];
temp2 = [fuel(2, 2:n_thermal), zeros(1, n_wind), fuel(2, (n_thermal + 1):end)];
temp = 2 * (repmat(temp1, 1, T) .* (x')) + repmat(temp2, 1, T);
temp1 = zeros(1, N * T);
for i = 1:T
    start = (i - 1) * N + 1;
    the_end = i * N;
    e = 2 * fuel(1, 1) * x1(i) + fuel(2, 1);
    temp2 = -e * D;
    temp1(start : the_end) = temp2;
end
g = temp + temp1;

