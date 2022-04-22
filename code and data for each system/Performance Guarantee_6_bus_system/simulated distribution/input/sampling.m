function sampling(num)
% num is the number of required sample size
load('case6.mat')

[A, B] = eig(r1);
eff = A * sqrt(B);
[~, dim] = size(eff);
s_sample = 2 * num;
data = [];
n_get = 0;

while(n_get < num)
    seeds = randn(dim, s_sample);
    temp_data = repmat(u1, 1, s_sample) + eff * seeds;
    
    temp_data = temp_data(:,sum(repmat(w_min, n_wind * T, s_sample) > temp_data) == 0);
    [~, new_length] = size(temp_data);
    temp_data = temp_data(:,sum(repmat(w_max1, n_wind * T, new_length) < temp_data) == 0);
    
    data = [data, temp_data];
    [~, n_get] = size(data);
end
save('data1.mat', 'data')