function [uhat, rhat] = nihe(data)
%% we assume each n_wind has the its unique w_min and w_max, and the w_min/w_max keeps the same during all the time periods
%as for the other parameters, the mean and the sigma, we use maximal
%likelihood esitimation

%The data is in the following form: each column is a sample, each row is a
%feature. Each column is [w_11, w_21, ..., w_{n_wind, 1}, w_12, ...,
%w_{n_wind, 2}, ..., w_{n_wind, T}]. (n_wind*T rows and n_sample columns).
[D, ~] = size(data);
data = data';
uhat = zeros(D, 1);
rhat = zeros(D, D);
for i = 1:D
    [~, phat, ~]  = fitdist_ntrunc(data(:, i));
    uhat(i) = phat(1);
    rhat(i, i) = phat(2)^2;
end
for i = 1:D
    for j = i+1:D
        X = [data(:, i), data(:, j)];
        [N, C] = hist3(X, [10, 10]);
%         rhat(i, j) = get_covariance1([uhat(i), uhat(j)], [rhat(i,i), rhat(j,j)] , X, min(X), max(X));
        rhat(i, j) = get_covariance([uhat(i), uhat(j)], [rhat(i,i), rhat(j,j)] , N, C);
        rhat(j, i) = rhat(i, j);
    end
end






% cons = (2*pi)^(-D/2);
% m = 500000;
% to_matrix = @(sigma) reshape(sigma, n_wind * T, n_wind * T);
% ratio = @(w_min, w_max, mu, sigma) qscmvnv(m, to_matrix(sigma), repmat(w_min, T, 1)-mu, eye(D), repmat(w_max, T, 1)-mu);
% TN = @(mu, sigma, w_min, w_max, x) cons * det(to_matrix(sigma))^(-0.5) * exp(- 0.5 * ((x - mu)'/to_matrix(sigma)) * (x - mu))./ratio(w_min, w_max, mu, sigma);
% 
% temp = min(data, [], 2);
% temp = temp';
% temp_min = zeros(n_wind, 1);
% temp_max = zeros(n_wind, 1);
% temp_ind = linspace(0, n_wind * (T - 1), T);
% for i = 1:n_wind
%     temp_ind = temp_ind + 1;
%     temp_min(i) = min(temp(temp_ind));
%     temp_max(i) = max(temp(temp_ind));
% end
% 
% [phat, phat_ci]  = mle(data,'pdf',TN,'Start',[mean(data, 2), reshape(cov(data'), (n_wind * T)^2, 1), temp_min, temp_max]);

