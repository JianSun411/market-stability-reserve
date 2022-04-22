function [ca, msr, z] = get_CE(xs, n, n_wind, demand, n_thermal, UCA, T)
D = [ones(1, n - 1), zeros(1, n_wind)];
consD = sum(demand); 
[~, the_n] = size(xs);
ca = zeros(1, the_n);
msr = zeros(1, the_n);
for i = linspace(1, the_n, the_n)
    x2 = xs(:, i);
    x2 = reshape(x2, n_thermal + 2 * n_wind - 1, T);
    x1 = consD - D * x2;
    profile = [x1; x2];
    tmp = sum(profile, 2);
    ca(i) = UCA(1:n_thermal) * tmp(1:n_thermal);
    msr(i) = UCA(n_thermal + 1:end) * tmp(n_thermal + n_wind + 1:end);  
end
z = ca + msr;