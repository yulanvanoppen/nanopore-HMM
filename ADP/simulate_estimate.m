clearvars
close all
rng('default')

%%
data = csvread('ADP/1000uMADP_1.csv', 2);
subsample = 10;
dt = data(subsample+1, 1);
y = reshape(data(:, 2:end), 1, []);
y = y(y ~= 0 & y > -300);
y = y(1:subsample:end);
T = length(y);
t = dt * (0:T-1);


%%
k = 100*[10, 1, 10, 10, 10, 1, 10, 10];
mu = [-203 -203 -226 -226 -241];
sd = 7*ones(1, 5);

M1 = .1;
Q1 = Qmat(k, M1);
G1 = abs(expm(dt*Q1));
mchain = dtmc(G1);
delta1 = asymptotics(mchain);
C1 = simulate(mchain, T-1, 'X0', [1 0 0 0 0]);
S1 = normrnd(mu(C1), sd(C1));

M2 = .2;
Q2 = Qmat(k, M2);
G2 = abs(expm(dt*Q2));
mchain = dtmc(G2);
delta2 = asymptotics(mchain);
C2 = simulate(mchain, T-1, 'X0', [1 0 0 0 0]);
S2 = normrnd(mu(C2), sd(C2));

M3 = 1;
Q3 = Qmat(k, M3);
G3 = abs(expm(dt*Q3));
mchain = dtmc(G3);
delta3 = asymptotics(mchain);
C3 = simulate(mchain, T-1, 'X0', [1 0 0 0 0]);
S3 = normrnd(mu(C3), sd(C3));

plot(t, [S1; S2; S3])
title('Simulated measurements')
legend('|ADP| = .1 mM', '|ADP| = .2 mM', '|ADP| = 1 mM')
xlabel('time (s)')
ylabel('current (pA)')


%%
options = optimoptions('fmincon', 'Display', 'iter');
lb = [2*ones(1, 8), mu-5, ones(1, 5)];
ub = [8*ones(1, 8), mu+5, 3*ones(1, 5)];

nstart = 5;
opts = zeros(nstart, length(lb));
vals = Inf(1, nstart);

parfor start = 1:nstart
    init = rand(size(lb)) .* (ub - lb) + lb;
    [opt_new, val_new] = fmincon(@(par) -likelihood(exp(par(1:8)), [M1 M2 M3], par(9:13), ...
                                     exp(par(14:18)), dt, [S1; S2; S3]), ...
                  init, [], [], [], [], lb, ub, [], options);
    opts(start, :) = opt_new;
    vals(start) = val_new;
end

vals
[~, idx] = min(vals);
opt = opts(idx, :);

k
k_opt = exp(opt(1:8))
mu
mu_opt = opt(9:13)
sd
sd_opt = exp(opt(14:18))

Q1opt = Qmat(k_opt, M1);
Q2opt = Qmat(k_opt, M2);
Q3opt = Qmat(k_opt, M3);

figure
tiledlayout(2, 3)
nexttile
showQ(Q1)
nexttile
showQ(Q2)
nexttile
showQ(Q3)
nexttile
showQ(Q1opt)
nexttile
showQ(Q2opt)
nexttile
showQ(Q3opt)

