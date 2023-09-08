%% Options and bounds
rng('default')
options = optimoptions('fmincon', 'Display', 'iter', 'OptimalityTolerance', 1e-5, ...
                       'StepTolerance', 1e-4, 'MaxIterations', 200, ...
                       'MaxFunctionEvaluations', 10000);

zero_ind = zeros(size([lb_k, lb_c]));
zero_ind(remove) = 1;

lb = [[lb_k, lb_c] - 4*zero_ind, lb_mu, lb_sd];
ub = [[ub_k, ub_c],              ub_mu, ub_sd];
k_len = length(lb_k) + length(lb_c);
mu_len = numel(mu);

% series_selection = [3 10 11 16 21 36 42 53 60 66 69 81 82];

selection.ATP = data.ATP(series_selection);
selection.AMP = data.AMP(series_selection);
selection.t = data.t(series_selection);
selection.y = data.y(series_selection);
selection.w = data.w(series_selection);

lengths = cellfun(@length, selection.t);
selection.t = cellfun(@(x) x(1:min(min(lengths), 50000)), selection.t, 'UniformOutput', false);
selection.y = cellfun(@(x) x(1:min(min(lengths), 50000)), selection.y, 'UniformOutput', false);
selection.w = ones(1, length(selection.w));


%% Multistarted optimization
nstart = 6;
opts = zeros(nstart, length(lb));
vals = Inf(1, nstart);
hess = zeros(length(lb), length(lb), nstart);

tic
parfor start = 1:nstart
    flag = -1;
    while flag < 0
        try
            init = rand(size(lb)) .* (ub - lb) + lb;
            [opt_new, val_new, flag,...
             ~, ~, ~, hess_new] = fmincon(@(p) -likelihood(10.^p(1:k_len), p(k_len+1:k_len+mu_len), ...
                                                                10.^p(k_len+mu_len+1:k_len+mu_len+5), zero_ind, selection), ...
                                         init, [], [], [], [], lb, ub, [], options);
            opts(start, :) = opt_new;
            vals(start) = val_new;
            hess(:, :, start) = hess_new
        catch ME
            disp(ME)
        end
    end
end
time_taken = toc


%% Extract optimized parameters
[~, best] = min(vals)
opt = opts(best, :);

k_opt = 10.^opt(1:k_len);
mu_opt = reshape(opt(k_len+1:k_len+mu_len), length(ATP_vals), []);
mu_opt = mu_opt(:, [1 2 2 3 3 4 4 2 3 5]);
sd_opt = 10.^opt(k_len+mu_len + [1 2 2 3 3 4 4 2 3 5]);