function [hugeC, highc, consD, D] = Sto_data_form(n_thermal, n_wind, demand, T, TLC, PTDF, ...,
min_p, max_p, ramp_down, ramp_up, g_0, gen_location)
% To transfer (A*x=b and B*x<=b) constraints into C*x<=c by variable
% substitution. A is a r * n matrix and rank(A) = r, x is a n * 1 column vector, and b is a
% r * 1 column vector. This function is aimed at the energy model. It is
% not suitable for arbitory parameters (A, a, B, b). A and a are decided by
% the load-demand balance constraints. B and b are decided by other
% deterministic constraints.

[n_line, n_bus] = size(PTDF);
n = n_thermal+n_wind;
N = n + n_wind -1;
%n_thermal: scaler, number of thermal generators
%n_wind: scalar, number of renewable generators
%demand: n_bus * T matrix, demand at each bus at each time period
%T: number of time periods
%TLC: n_line * 1 vector, transmission line capacity
%PTDF: n_line * n_bus matrix, power transifer distribution factor
%min_p, max_p: n_thermal * 1 vectors, minimal/maximal generation 
%carbon_allow, MSR: scalars, carbon allowances and market stability reserve
%ramp_down, ramp_up: n_thermal * 1 vectors, minimal ramping down/up constraints
%g_0: n_thermal * 1 vectors, the initial states of the thermal generators
%gen_location: n_bus * 1 vector, recording the generators' locations
%x: the decision variable x = [x_thermal; x_total_wind; x_equipped], which
%is a (n + n_wind) * T matrix. x_thermal is a n_thermal * T
%matrix. x_equipped and x_total_wind are n_wind * T matrices.
% Later, we will reshape  x(2:end, :) into a vector x_v = [x_i2; x_i3;...;x_iT], 
% where x_it = [x_2t;...,x_(n+n_wind)t]

%(3.1) load-demand balance constraint
D = [ones(1, n - 1), zeros(1, n_wind)];
consD = sum(demand); %1 * T vector
% the load-demand balance constraint is x(1, :) + D * x(2:end, :) = consD.

%we first consider the constraints that hold for any t
% (3.2) transmission line capacity cosntraints: (PTDF * x <= PTDF * d +
% repmat(TLC, 1, T) ) and (- PTDF * x <= - PTDF * d + repmat(TLC, 1, T)).
E = zeros(n_bus, n+n_wind);%turn the generator-based generation matrix x into
%bus-based generation matrix.
for i = 1:n
    E(gen_location(i), i) = 1;
end
% E * x is the generation of each generator at each period
F = PTDF * E;
G = PTDF * demand;
TLCC = repmat(TLC, 1, T);
tempC1 = F(:, 2:end) - F(:, 1) * D; % n_line * (n + n_wind - 1)
tempc1 = G + TLCC - F(:, 1) * consD; % n_line * T
tempC2 = -tempC1;
tempc2 = -G +TLCC+F(:, 1) * consD;


%(3.3) genaration capacity
tempC3 = -D;
tempc3 = max_p(1) - consD;
tempC4 = D;
tempc4 = consD - min_p(1);
tempC5 = [eye(n_thermal - 1), zeros(n_thermal - 1, 2 * n_wind)];
tempc5 = repmat(max_p(2:end), 1, T);
tempC6 = - tempC5;
tempc6 = -repmat(min_p(2:end), 1, T);

tempC = [tempC1; tempC2; tempC3; tempC4; tempC5; tempC6];
[L, ~] = size(tempC);
tempc = [tempc1; tempc2; tempc3; tempc4; tempc5; tempc6];
% The above constraints can be written as tempC * x(2:end, :) <= tempc.
% if we reshape x(2:end, :) as a vector x_v = [x_i2; x_i3;...;x_iT], 
% where x_it = [x_2t;...,x_(n+n_wind)t], the above constraints should be
% rewritten as hugeC * x_v <= highc:
hugeC = zeros(L*T, N*T);
for i = 1 : T
    row_start = (i - 1) * L + 1;
    row_end = i * L;
    column_start = (i - 1) * N + 1;
    column_end = i * N;
    hugeC(row_start:row_end, column_start:column_end) = tempC;
end
highc = reshape(tempc, L*T, 1);

% Then consider the constraints that hold for each generator i, they can be
% written as x * tempC <= tempc
%(3.5) ramping constraints
J = [eye(n_thermal-1), zeros(n_thermal - 1, 2 * n_wind)];
tempC1 = zeros(2 * (n_thermal-1) * (T-1), N * T);
for i = 1:T-1
    row_start = (i-1)*(n_thermal-1) + 1;
    row_end = i * (n_thermal-1);
    column_start = (i-1)*N+1;
    column_end = column_start + 2 * N - 1;
    tempC1(row_start:row_end, column_start:column_end) = [-J, J];
    row_start = row_start + (n_thermal-1)*(T-1);
    row_end = row_end + (n_thermal-1)*(T-1);
    tempC1(row_start:row_end, column_start:column_end) = [J, -J];
end
tempc1 = [repmat(ramp_up(2:end), T-1, 1); repmat(ramp_down(2:end), T-1, 1)];
%tempC1: ramping of 2:T periods of non-substituded generators

tempC2 = [J, zeros(n_thermal-1, N * (T - 1))];
tempc2 = g_0(2:end) + ramp_up(2:end);
tempC3 = [-J, zeros(n_thermal-1, N * (T - 1))];
tempc3 = -g_0(2:end) + ramp_down(2:end);
%tempC2/3: ramping of the first periods of non-substituded generators

tempC4 = [-D, zeros(1, N*(T-1))];
tempc4 = [g_0(1) + ramp_up(1) - consD(1)];
tempC5 = [D,  zeros(1, N*(T-1))];
tempc5 = [-g_0(1)+ramp_down(1)+consD(1)];
%tempC4/5: ramping of the first periods of substituded generators

tempC8 = zeros(2*(T-1), N*T);
tempc8 = zeros(2*(T-1), 1);
for i = 1:T-1
    row_start = 2 * ( i - 1 ) + 1;
    row_end = 2 * i;
    column_start = (i-1) * N + 1;
    column_end = column_start + 2 * N -1;
    tempC8(row_start:row_end, column_start: column_end) = [D, -D; -D, D];
    tempc8(row_start:row_end) = [ramp_up(1)-consD(i+1)+consD(i); ramp_down(1)+consD(i+1)-consD(i)];
end
%tempC8: ramping of the 2:T periods of substituded generators


hugeC = [hugeC; tempC1; tempC2; tempC3; tempC4; tempC5; tempC8];
highc = [highc; tempc1; tempc2; tempc3; tempc4; tempc5; tempc8];





















