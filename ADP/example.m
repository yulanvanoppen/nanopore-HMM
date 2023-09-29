%% Generate data
clearvars
close all
rng('default')

k = 10.^[4 3 1 2 2 2 -5 -5 5 3 1 4 1 3 2 3 3 0 2 0 2 0 2 0];
mu = [-180 -203 -203 -212 -212 -226 -226 -203 -212 -241];
sd = 7*ones(1, 10);

dt = 2e-5;
t = 0:dt:.5;
T = length(t);

ADP1 = .01;
Q1 = Qmat(k, ADP1);
G1 = abs(expm(dt*Q1));
mchain = dtmc(G1);
delta1 = asymptotics(mchain);
C1 = simulate(mchain, T-1, 'X0', [0 1 0 0 0 0 0 0 0 0]);
S1 = normrnd(mu(C1), sd(C1));

ADP2 = .05;
Q2 = Qmat(k, ADP2);
G2 = abs(expm(dt*Q2));
mchain = dtmc(G2);
delta2 = asymptotics(mchain);
C2 = simulate(mchain, T-1, 'X0', [0 1 0 0 0 0 0 0 0 0]);
S2 = normrnd(mu(C2), sd(C2));

ADP3 = 1;
Q3 = Qmat(k, ADP3);
G3 = abs(expm(dt*Q3));
mchain = dtmc(G3);
delta3 = asymptotics(mchain);
C3 = simulate(mchain, T-1, 'X0', [0 1 0 0 0 0 0 0 0 0]);
S3 = normrnd(mu(C3), sd(C3));

data = struct();
data.ADP = [ADP1 ADP2 ADP3];
data.t = repmat({t}, 1, 3);
data.y = {S1 S2 S3};
data.w = [1 1 1];

figure
tl = tiledlayout(3, 1);
title(tl, 'Simulated measurements')

nexttile
plot(t, S1, 'Color', '#0072BD')
title('|ADP| = .01 mM')
ylim([-260 -170])

nexttile
plot(t, S2, 'Color', '#D95319')
title('|ADP| = .05 mM')
ylabel('current (pA)')
ylim([-260 -170])

nexttile
plot(t, S3, 'Color', '#EDB120')
title('|ADP| = 1.00 mM')
xlabel('time (s)')
ylim([-260 -170])


%%
options = optimoptions('fmincon', 'Display', 'iter', 'FunctionTolerance', 1e-5, ...
                       'StepTolerance', 1e-4, 'MaxIterations', 200, ...
                       'MaxFunctionEvaluations', 20000);

k_len = 24;
mu_all = repmat([-180 -203 -212 -226 -241], 1, 7);
mu_len = length(mu_all);
lb = [1*ones(1, k_len), mu_all-5,   ones(1, 10)];
ub = [6*ones(1, k_len), mu_all+5, 3*ones(1, 10)];

nstart = 6;
opts = zeros(nstart, length(lb));
vals = Inf(1, nstart);

tic
parfor start = 1:nstart
    flag = -1;
    while flag < 0
        try
            init = rand(size(lb)) .* (ub - lb) + lb;
            [opt_new, val_new, flag, ...
                  ~, ~, ~, hess_new] = fmincon(@(p) -likelihood(10.^p(1:k_len), p(k_len+1:k_len+mu_len), ...
                                                                10.^p(k_len+mu_len+1:k_len+mu_len+5), ...
                                                                zeros(1, k_len), data), ...
                                               init, [], [], [], [], lb, ub, [], options);
            opts(start, :) = opt_new;
            vals(start) = val_new;
        catch ME
            disp(ME)
        end
    end
end
time_taken = toc

[~, best] = min(vals)
opt = opts(best, :);

k_opt = 10.^opt(1:k_len);
ADP_values = [1e-2 2e-2 5e-2 1e-1 2e-1 5e-1 1e0];
mu_opt = reshape(opt(k_len+1:k_len+mu_len), length(ADP_values), []);
mu_opt = mu_opt(:, [1 2 2 3 3 4 4 2 3 5]);
sd_opt = 10.^opt(k_len+mu_len + [1 2 2 3 3 4 4 2 3 5]);

Q1opt = Qmat(k_opt, ADP1);
Q2opt = Qmat(k_opt, ADP2);
Q3opt = Qmat(k_opt, ADP3);


%%
G1opt = abs(expm(dt*Q1opt));
mchain = dtmc(G1opt);
delta1 = asymptotics(mchain);
C1opt = simulate(mchain, T-1, 'X0', [0 1 0 0 0 0 0 0 0 0]);
S1opt = normrnd(mu_opt(ADP1 == ADP_values, C1opt), sd_opt(C1opt));

G2opt = abs(expm(dt*Q2));
mchain = dtmc(G2opt);
delta2 = asymptotics(mchain);
C2opt = simulate(mchain, T-1, 'X0', [0 1 0 0 0 0 0 0 0 0]);
S2opt = normrnd(mu_opt(ADP2 == ADP_values, C2opt), sd_opt(C2opt));

G3opt = abs(expm(dt*Q3opt));
mchain = dtmc(G3opt);
delta3 = asymptotics(mchain);
C3opt = simulate(mchain, T-1, 'X0', [0 1 0 0 0 0 0 0 0 0]);
S3opt = normrnd(mu_opt(ADP3 == ADP_values, C3opt), sd_opt(C3opt));


figure
tl = tiledlayout(3, 1);
title(tl, 'Fitted model simulations')

nexttile
plot(t, S1opt, 'Color', '#0072BD')
title('|ADP| = .01 mM')
ylim([-260 -170])

nexttile
plot(t, S2opt, 'Color', '#D95319')
title('|ADP| = .05 mM')
ylabel('current (pA)')
ylim([-260 -170])

nexttile
plot(t, S3opt, 'Color', '#EDB120')
title('|ADP| = 1.00 mM')
xlabel('time (s)')
ylim([-260 -170])

