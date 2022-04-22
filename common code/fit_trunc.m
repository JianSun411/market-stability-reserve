function [uhat, rhat, minhat, maxhat]  = fit_trunc(dat_normal, x_min, x_max)
%dat_normal: n_sample * n_feature matrix of the samples
%x_min: n_feature * 1 vector indicating the lower bound of the truncated
%data
%x_max: n_feature * 1 vector indicating the upper bound of the truncated
%data

mu = mean(dat_normal);
n_feature = length(mu);
mu = mu';
x_0 = [mu; x_min; x_max];
sig = cov(dat_normal);
temp = [];
for i = 1:n_feature
    temp = [temp; sig(1:i, i)];
end
x_0 = [x_0; temp];
n_variable = length(x_0);
fun = @(x)siran(dat_normal, x);

n = n_feature;
A1 = [-eye(n), zeros(n, n_variable - n)]; % - uhat <= 0
b1 = zeros(n, 1); % - uhat <= 0
A2 = [zeros(n), -eye(n), zeros(n, n_variable - 2 * n)]; % - minhat <= 0
b2 = zeros(n, 1); % - minhat <= 0
A3 = [zeros(n), eye(n), -eye(n), zeros(n, n_variable - 3 * n)];% minhat - maxhat <= 0
b3 = zeros(n, 1);% minhat - maxhat <= 0
A4 = [zeros(n), eye(n), zeros(n, n_variable - 2 * n)]; %minhat <= x_min
b4 = x_min;%minhat <= x_min
A5 = [zeros(n), zeros(n), -eye(n), zeros(n, n_variable - 3 * n)];% - maxhat <= - x_max
b5 = - x_max;% - maxhat <= - x_max
A = [A1; A2; A3; A4; A5];
b = [b1; b2; b3; b4; b5];
Aeq = [];
beq = [];
lb = -inf * ones(n_variable, 1);
ub = inf * ones(n_variable, 1);
con = @(x)nonlcon(n_feature, x);

options = optimoptions('fmincon','Display','iter', 'MaxFunctionEvaluations', 30000, 'UseParallel', true);
mu
x = fmincon(fun,x_0,A,b,Aeq,beq,lb,ub,con, options);
uhat = x(1:n_feature);
minhat = x(n_feature + 1 : 2 * n_feature);
maxhat = x(2 * n_feature + 1 : 3 * n_feature);
rhat = zeros(n_feature, n_feature);
index = 3 * n_feature + 1;
for i = 1:n_feature
    temp = x(index: index + i - 1);
    rhat(1:i, i) = temp;
    rhat(i, 1:i) = temp';
    index = index + i;
end
end

function [zhengding, ha] = nonlcon(n_feature, x)
sigma = zeros(n_feature, n_feature);
index = 3 * n_feature + 1;
for i = 1:n_feature
    temp = x(index: index + i - 1);
    sigma(1:i, i) = temp;
    sigma(i, 1:i) = temp';
    index = index + i;
end
[~, D] = eig(sigma);
zhengding = eps - min(diag(D));
ha = [];
end


function lh = siran(data, x)
[n_sample, n_feature] = size(data);
mu = x(1:n_feature);
x_min = x(n_feature+1: 2 * n_feature);
x_max = x(2 * n_feature + 1: 3 * n_feature);
index = 3 * n_feature + 1;
sigma = zeros(n_feature, n_feature);
for i = 1:n_feature
    temp = x(index: index + i - 1);
    sigma(1:i, i) = temp;
    sigma(i, 1:i) = temp';
    index = index + i;
end
%mu, x_min, x_max: n_feature * 1 vectors
%sigma: n_feature * n_feature matrix

temp1 = ((data - repmat(mu', n_sample, 1)) / sigma) * (data' - repmat(mu, 1, n_sample));
temp1 = diag(temp1);
temp1 = sum(temp1);
temp3 = n_sample * log(det(sigma));
Cons = qscmvnv(50000, sigma, x_min - mu, eye(n_feature), x_max - mu);
% mvncdf(x_min, x_max, mu, sigma);
temp2 = 2 * n_sample * log(Cons);
lh = temp1 + temp2 + temp3;
end


