function [x_star, H, niter] = small_acent(A,b,x_0)
n = length(x_0);
cvx_begin quiet
    cvx_solver SDPT3
    variable x(n)
    minimize -sum(log(b-A*x))
cvx_end
x_star = x;
H = cvx_status;
niter = 0;
end