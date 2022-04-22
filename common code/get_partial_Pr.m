function [dp, e] = get_partial_Pr(m, n, u, r, a, b, A, x) 
%calculated the \paritial F(z)/z_i where z follows the Truncated Normal
%distribution TN(mu, sigma, a, b), which can be refomulated as (1/Pr(\xi <= z))*\partial PrN([I;-I]*\xi <= [min(z, b);-a])
% \partial PrN([I;-I]*\xi <= [min(z, b);-a]) is calculated based on Theorem 3.3 in "A Gradient Formula for Linear
%Chance Constraints Under Gaussian Distribution". (why the formulation satisfies the requirement are proved in my paper)

z = A * x;
if ismember(0, max(z, a) - a)
    dp = zeros(1, n) * A;
else
    zz = [min(z, b); -a];
    dp = ones(1, n);
    bigA = [eye(n); -eye(n)];
    for i = 1:n
        if z(i) >= b(i)
            dp(i) = 0;
        else
            ajT = bigA(i,:);
            %the mean
            new_mu = ajT * u;
            new_sigma = ajT * r * ajT';
            temp1 = normpdf(zz(i),new_mu,sqrt(new_sigma));
            % one-dimensional normal probability
            
            %the variance
            temp2 = 1/new_sigma;
            temp3 = r * ajT' * ajT * r;
            S = r - temp2 * temp3;
            [s, ~] = size(S);
            [V, D] = eig(S);
            [~, j] = min(diag(D)); %D(j, j) == 0 and the j-th column of V should be delete
            V(:, j) = [];
            D(:, j) = [];
            D(j, :) = [];
            L = V * sqrt(D);
            
            w = (zz(i) - ajT * u) /new_sigma;
            w = w * r * ajT' + u;
            new_A = bigA;
            new_A(i, :) = [];
            coeffi = new_A * L;
            new_zz = zz;
            new_zz(i) = [];
            bound = new_zz - new_A * w;
            [temp4, e(i)] = qscmvnv(m, eye(s-1), -inf*ones(length(bound), 1), coeffi, bound);
            dp(i) = temp1 * temp4;    
        end
    end
    dp = - (dp * A); 
end

%this code is tested with "cutting_plane" function


