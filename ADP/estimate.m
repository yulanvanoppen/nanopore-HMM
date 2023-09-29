%% Load data
clearvars
load_process


%% Random time series selection and plot data
close all
ADP_values = [1e-2 2e-2 5e-2 1e-1 2e-1 5e-1 1e0];
% series_selection = [5 17 21 24 28 32 37];

rng('default')
series_selection = [randi([ 1 11]) ...
                    randi([12 19]) ...
                    randi([20 22]) ...
                    randi([23 27]) ...
                    randi([28 30]) ...
                    randi([31 35]) ...
                    randi([36 39])];

f1 = figure('WindowState', 'maximized');
tl = tiledlayout(ceil(length(series_selection)/1), 1);
tl.Title.String = 'Observed data';

for idx = series_selection
    nexttile
    plot(data.t{idx}, data.y{idx})
    title(replace(files(seg_file_indices(idx)), '_', '\_'))
    ylim([-260 -160])
    xlabel('time (sec)')
    ylabel('current (pA)')
end


%% Setup optimization and fit rates
mu = mu_segments();
mu = reshape(mu(series_selection, :), 1, []);

lb_k = -ones(1, 16);
ub_k = 6*ones(1, 16);

lb_k(1) = 4;
lb_k(9) = 4;
lb_k(12) = 4;
lb_k(13) = 1;
lb_k(14) = 4;
lb_k(15) = 2.25;

ub_k(1) = 4.75;
ub_k(3)  = -.3 ;
ub_k(4)  = 1.3 ;
ub_k(5) = 3;
ub_k(6) = 3;
ub_k(11) = 1.7;
ub_k(13) = 1.7;
ub_k(15) = 2.5;
ub_k(16) = 3.5;

lb_c = repmat([2 -3], 1, 4);
ub_c = repmat([6  1], 1, 4);

lb_mu = mu-3;
ub_mu = mu+3;

lb_sd = .5*ones(1, 5);
ub_sd = ones(1, 5);

remove = [7 8];

fit


%% Plot (log) optima
figure
b = bar(opts(:, [1:k_len k_len+mu_len+1:end])', 'FaceColor', 'flat');
set(gca, 'XTick', [1:24 25:29])
set(gca, 'XTickLabel', {'k_1' 'k_2' 'k_3' 'k_4' 'k_5' 'k_6' 'k_7' 'k_8' ...
                        'k_9' 'k_{10}' 'k_{11}' 'k_{12}' 'k_{13}' 'k_{14}' 'k_{15}' 'k_{16}' ...
                        'c_1' 'c_2' 'c_3' 'c_4' 'c_5' 'c_6' 'c_7' 'c_8' ...
                        'sd_1' 'sd_2' 'sd_3' 'sd_4' 'sd_5'})
ylabel('log_1_0 optimum')
title('Optimum per initialization (winner highlighted)')
for i = 1:nstart, b(i).CData = b(1).CData; end
b(best).CData = repmat([0 0.8 0.8], size(b(best).CData, 1), 1);


%% Generate synthetic data from fitted HMM
simulate

figure('WindowState', 'maximized')
tl = tiledlayout(ceil(length(series_selection)/1), 1);
tl.Title.String = 'Simulated emissions';

for idx = series_selection
    nexttile
    plot(data.t{idx}, data.simulated_emission{idx})
    title(sprintf('|ADP| = %.3f mM', ADP_values(idx == series_selection)));
    ylim([-260 -160])
    xlabel('time (sec)')
    ylabel('current (pA)')
end

figure('WindowState', 'maximized')
tl = tiledlayout(ceil(length(series_selection)/1), 1);
tl.Title.String = 'Simulated states';

for idx = series_selection
    nexttile
    plot(data.t{idx}, data.simulated_chain{idx})
    title(sprintf('|ADP| = %.3f mM', ADP_values(idx == series_selection)));
    xlabel('time (sec)')
    ylabel('state (index)')
end


%% Predict LID closing and opening rates
closing_opening

figure
tiledlayout(1, 2)
nexttile
plot(ADP_values, rates(:, 1))
title('LID closing')
xlabel('|ADP| (mM)') 
ylabel('rate (sec^-^1)')

nexttile
plot(ADP_values, rates(:, 2))
title('LID opening')
xlabel('|ADP| (mM)')
ylabel('rate (sec^-^1)')


