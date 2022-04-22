function lb = bound(minimal_f, C, d, constraint_label)
d = 100 * d; %enlarge the coefficient while keep the optimizer unchanged
minimal_f = 100 * minimal_f;
[~, n_random] = size(C);
loc = find(constraint_label == 1);
original_C = C(loc, :);
original_c = d(loc);
loc2 = find(constraint_label == 2);
objective_C = C(loc2, :);
objective_c = d(loc2);
loc3 = find(constraint_label == 3);
constraint_C = C(loc3, :);
constraint_c = d(loc3);

if isempty(loc2)
    lb = -inf;
elseif isempty(loc3)
    cvx_begin quiet
        variables x(n_random) t
        minimize t
        subject to 
            if isempty(loc) == 0
                original_C * x <= original_c;
                objective_C * x + minimal_f' - objective_c <= repmat([t], length(objective_c), 1);
            else
                objective_C * x + minimal_f' - objective_c <= repmat([t], length(objective_c), 1);
            end
    cvx_end
    lb = cvx_optval * 0.01;
else
    cvx_begin quiet
        variables x(n_random) t
        minimize t
        subject to 
            if isempty(loc) == 0
                original_C * x <= original_c;
                constraint_C * x <= constraint_c;
                objective_C * x + minimal_f' - objective_c <= repmat([t], length(objective_c),1);
            else
                constraint_C * x <= constraint_c;
                objective_C * x + minimal_f' - objective_c <= repmat([t], length(objective_c),1);
            end
    cvx_end
    lb = cvx_optval * 0.01;
end

