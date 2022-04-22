function [p, e] = get_Pr(m, A, x, r, u, w_min, w_max)
% calculate Pr(\xi <= A*x) where the \xi is a random variable following
% the distribution TN(u, r, w_min, w_max)
% m: the number of samples
% deno: decided by r, acts as a parameter to reduce rebundant
% calculations
% the probability calculation comes from section 4.7 in "A Gradient Formula 
%for Linear Chance Constraints Under Gaussian Distribution"
if ismember(0, max(A * x, w_min)-w_min) 
    p = 0;
    e = 0;
else
    [p, e] = qscmvnv(m, r, w_min - u, eye(length(u)), min(A * x, w_max) - u);
end