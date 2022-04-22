function sigma = get_covariance(u, r, N, C)
[m, n] = size(N);
maximal = max(max(N));
[max_row, max_col] = find(N == maximal);

new_N = log(N./maximal);
new_N = -2 * new_N;
inde = new_N ~= inf;

xasix = C{1, 1};
yasix = C{1, 2};

dataX = [];
datay = [];
for i = 1:m
    for j = 1:n
        if inde(i, j) == 1
            dataX = [dataX; [xasix(i), yasix(j)]];
            datay = [datay; new_N(i, j)];
        end
    end
end
n_sample = length(datay);
new_u = repmat(u, n_sample, 1);
base = repmat([xasix(max_row(1)), yasix(max_col(1))], n_sample, 1) - new_u;

mymatrix = @(sigma) [r(1), sigma; sigma, r(2)];
myfun = @(sigma, x) diag((x - new_u) / mymatrix(sigma) * (x - new_u)') - diag((base / mymatrix(sigma)) * base');

% sigma = lsqcurvefit(myfun,0,dataX,datay);
sigma = nlinfit(dataX,datay,myfun,0);
