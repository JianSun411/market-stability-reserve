function [x, iter, f_best, l_best, t, x_his, Pr_his, C_his, c_his, eps, flag] = myaccpm_drop(n_decision, fuel_cost, C_0, c_0, A, p, r, u, ...,
    w_min, w_max, consD, bigD, n_thermal, n_wind, T, niter, m, thre)
% compute the optimal solution of P6
% the objective is fuel*x, the constraints are C_0 * x <= c_0 and Pr(\xi <= A * x)>=p
% the truncated normal distribution is TN(u, r, w_min, w_max)
%n_decision is the number of decision variables
%fuel_cost is a n_decision * 2 matrix, where fuel_cost(i,
%1)*g_i^2+fuel_cost(i, 2)*g_i is the generation cost.
%********************************************************************
% cutting plane method written by Jian Sun
%********************************************************************
t = 0;
tic;

%% parameter setting
n = length(u); % number of random variables
deno = qscmvnv(m, r, w_min - u, eye(n), w_max - u);

%% initialization
C = [C_0; -A];
c = [c_0; -w_min]; % initial localization polyhedron {x | C_0 * x <= c_0}
new_fuel = [fuel_cost(:, 1:n_thermal), zeros(2, n_wind), fuel_cost(:, (n_thermal + 1):end)];

cvx_begin quiet
    variables z(n_decision) pro(n_thermal + 2 * n_wind, T) 
    minimize new_fuel(1, :) * sum(pro.^2, 2) + new_fuel(2, :) * sum(pro, 2)
    subject to
        C * z <= c;
        pro(2:end, :) == reshape(z, [n_thermal + 2 * n_wind - 1, T]);
        pro(1, :) == consD - bigD * pro(2:end, :);
cvx_end
l_best = zeros(1, niter);%record the lower bound
l_best(1) = cvx_optval;

iter = 1; % number of iterations
epsilon = 1; % the current accuracy
x = zeros(n_decision,1);  % initial point
[ini_m, ~] = size(C);
g_his = zeros(niter, n_decision); %history of returned g
x_his = zeros(n_decision, niter); %history of returned x, x is a column
Pr_his = zeros(1, niter); %history of the chance constraints value
f_best = []; %the currnt results
minimal_f = []; %the current best results
constraint_label = ones(ini_m, 1); %recording the source of constraints, 1 means the original constraints
%2 means from f_0, 3 means from the Pr constraint.
C_his = cell(1, niter);
c_his = cell(1, niter);
flag = 'ha';
%% cutting plane method
while (iter <= niter) && (epsilon >= thre)
    C_his{iter} = C;
    c_his{iter} = c;
 %% find analytical center of polyhedron
    cvx_begin quiet
        cvx_solver Mosek
        variable y(n_decision, 1)
        minimize 1
        subject to
            C * y <= c;
    cvx_end
    if ~contains(cvx_status, 'Solved')
        flag = 'wrong';
        save('infeasible poly.mat')
        qisil = 'HEREHERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
        break
    end
    cvx_begin quiet
    cvx_solver Mosek
        variable y(n_decision, 1)
        minimize -sum(log(c-C*y))
    cvx_end
    H = cvx_status;
    if contains(H, 'Solved')
        small_flag = 1;
        x = y;
        aha = 0;
    else
        [x, H, aha] = acent(C,c,zeros(n_decision, 1));
        what = c - C * x;
        small_flag = 0;
        if sum(what < 0) > 0
            [x, H, aha] = small_acent(C,c,zeros(n_decision, 1));
            small_flag = 1;
            if ~contains(H, 'Solved')
                flag = 'wrong';
                save('cannot get center.mat')
                qisil = 'HEREHERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
                break
            end
        end 
    end

        
    x_his(:, iter) = x;
    Pr = get_Pr(m, A, x, r, u, w_min, w_max);
    probability = Pr/deno;% the probability of TN(u, r, w_min, w_max), the integration region is \xi<=A * x
    Pr_his(iter) = -log(probability)+log(p);
    
%% drop function      
    % ranking and dropping constraints 
   if mod(iter, 10) == 0
%        if small_flag == 0
%            temp1 = c - C * x; 
%            temp2 = length(c)*sqrt(diag(C*(H\C')));
%            rs = temp1./temp2; %\eta in the notes, when \eta > m, the related constraint is rebundant 
%            ind = rs<=length(c) ; 
%            C = C(ind, :);
%            c = c(ind);
%            constraint_label = constraint_label(ind);
%            [~, ~, loc] = intersect(find(ind == 1), find(constraint_label == 2));
%            minimal_f = minimal_f(loc);
%        end
       l_best(iter) = bound(minimal_f, C, c, constraint_label);%calculate the lower bound of the optimizer
   end
%     l_best(iter) = bound(minimal_f, C, c, constraint_label);
%% find the cutting plane
    if Pr_his(iter) <= 0 
        [total_cost, g] = f_0(fuel_cost, x, consD, bigD, n_thermal, n_wind, T);
        f_best = [f_best, total_cost];
        minimal_f = [minimal_f, min(f_best)];
        best = minimal_f(end);
        nb = -total_cost + g * x + best; %when the state is "feasible", the two variables, returned g and returned nb,are not necessary to be returned.
        constraint_label = [constraint_label; 2];
    else 
        g = get_partial_Pr(m, n, u, r, w_min, w_max, A, x)./Pr; % according to the Page 4 in the accpm_slides
        nb = -Pr_his(iter) + g * x;
        constraint_label = [constraint_label; 3];
    end
    g_his(iter, :) = g;
%% update polyhedron, best function values and the lower bound
    % update polyhedron
    C = [C; g]; 
    c = [c; nb]; 

    if isempty(f_best)
        epsilon = 1;
    else
        epsilon = abs((best - max(l_best(1: iter))))/best;
    end
    iter = iter + 1;
   if mod(iter, 50) == 0
       eps = min(f_best) - max(l_best)
    end
end
%l_best = l_best(1:min(iter, niter));
eps = min(f_best) - max(l_best);

if eps < 0
    save('made.mat')
    qisil = 'HEREHERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
end
% p_star = best;
t = t + toc;
end


%% the above code is tested by the following problem
% fuel = [1 1]
% C_0 = [-2, -3; 2, 3; -1, 0; 0, -1]
% c_0 = [-5; 7; 0; 0]
% A = [-3, -2]
% p = -7
% the parameter is setted as: niter = 200, thre = 1e-3


