clearvars
load_process


%%
close all
M_vals = [1e-2 2e-2 5e-2 1e-1 2e-1 5e-1 1e0];
series_selection = [5 17 21 24 28 32 37];

% rng(4)
% series_selection = [randi([ 1 11]) ...
%                     randi([12 19]) ...
%                     randi([20 22]) ...
%                     randi([23 27]) ...
%                     randi([28 30]) ...
%                     randi([31 35]) ...
%                     randi([36 39])];

filter_size = 1; t0 = 0; t1 = 100;

f1 = figure('WindowState', 'maximized');
% f1.Position = [0 48 1720 1300];
tl = tiledlayout(ceil(length(series_selection)/1), 1);
tl.Title.String = 'Observed data';

for idx = series_selection
    nexttile
    subint = data.t{idx} >= t0 & data.t{idx} < t1;
    plot(data.t{idx}(subint), ...
         filter(ones(1, filter_size)/filter_size, 1, data.y{idx}(subint)))
    title(replace(files(seg_file_indices(idx)), '_', '\_'))
    ylim([-260 -160])
    xlabel('time (sec)')
    ylabel('current (pA)')
end

% f2 = figure;%('WindowState', 'maximized');
% f2.Position = [1720 48 1720 1300];
% ksdensity(filter(ones(1, filter_size)/filter_size, 1, ...
%                  data.y{idx}(data.t{idx} >= t0 & data.t{idx} < t1)))
% xlim([-250 -170])


%%
% files = "ADP/10uM_ADP_3.csv";           % -180, -197, -210, -222
% files = "ADP/20uM_ADP_2.csv";           % -180, -200, -212, -225
% files = "ADP/50uMADP_2.csv";            %       -197, -211, -223
% files = "ADP/100uMADP_1.csv";           %       -205,       -228
% files = "ADP/200uMADP_1.csv";           %       -205,       -229
% files = "ADP/500uMADP_1.csv";           %             -209, -228, -241
% files = "ADP/1000uMADP_2.csv";          %                   -229, -242

% mu = reshape([-180 -197 -210 -222 -241;
%               -180 -200 -212 -225 -241;
%               -180 -197 -211 -223 -241;
%               -180 -205 -210 -228 -241;
%               -180 -205 -210 -229 -241;
%               -180 -197 -209 -228 -241;
%               -180 -197 -210 -229 -242], 1, []);
          
mu = mu_segments();
mu = reshape(mu(series_selection, :), 1, []);

lb_k = -ones(1, 16);
ub_k = 6*ones(1, 16);

% lb_k([1 5 10 11 12 14 15]) = [2 2 3 2 3.5 4.5 2.25];
% ub_k([1 5 6 9 11 12 13 15 16]) = [3.75 2 3 5.25 2.5 5 2 3 3.5];

lb_k(1) = 4;
% lb_k(5) = 1;
lb_k(9) = 4;
% lb_k(11) = 1;
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
% remove = [];

fit


%%
emitted_transitions

figure
tiledlayout(1, 2)
nexttile
showQ(Qopt(:, :, 1), sprintf('Qopt (|ADP|=%.2f)', M_vals(1)), true)
nexttile
showQ(Qopt(:, :, end), sprintf('Qopt (|ADP|=%.2f)', M_vals(end)), true)

figure, hold on
semilogx(M_vals, [M_M1; M_M2]', ':')
semilogx(M_vals, [M1_M; M1_M2]', '-.')
semilogx(M_vals, [M2_M; M2_M1; M2_M3]', '--')
legend('M-M1', 'M-M2', 'M1-M', 'M1-M2', 'M2-M', 'M2-M1', 'M2-M3')
title('State change distributions w.r.t. |ADP|')
xlabel('|ADP| (mM)')
ylabel('fraction')
set(gca, 'XScale', 'log');
hold off

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


%%
figure
[V, D] = eig(cov(opts(:, 1:24)));
lambda = diag(D);
bar(V(:, end-2:end));
set(gca, 'XTick', 1:24)
set(gca, 'XTickLabel', {'k_1' 'k_2' 'k_3' 'k_4' 'k_5' 'k_6' 'k_7' 'k_8' ...
                        'k_9' 'k_{10}' 'k_{11}' 'k_{12}' 'k_{13}' 'k_{14}' 'k_{15}' 'k_{16}' ...
                        'c_1' 'c_2' 'c_3' 'c_4' 'c_5' 'c_6' 'c_7' 'c_8'})
title("Largest eigenvalues' eigenvectors")
legend(sprintf("lambda = %.3f", lambda(end-2)), ...
       sprintf("lambda = %.3f", lambda(end-1)), ...
       sprintf("lambda = %.3f", lambda(end)))


%%
simulate

figure('WindowState', 'maximized')
tl = tiledlayout(ceil(length(series_selection)/1), 1);
tl.Title.String = 'Simulated emissions';

for idx = series_selection
    nexttile
    plot(data.t{idx}, data.simulated_emission{idx})
    title(sprintf('|ADP| = %.3f mM', M_vals(idx == series_selection)));
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
    title(sprintf('|ADP| = %.3f mM', M_vals(idx == series_selection)));
    xlabel('time (sec)')
    ylabel('state (index)')
end


%%
closing_opening

figure
tiledlayout(1, 2)
nexttile
plot(M_vals, rates(:, 1))
title('LID closing')
xlabel('|ADP| (mM)') 
ylabel('rate (sec^-^1)')

nexttile
plot(M_vals, rates(:, 2))
title('LID opening')
xlabel('|ADP| (mM)')
ylabel('rate (sec^-^1)')


