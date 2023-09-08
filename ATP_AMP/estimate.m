clearvars
load_process


%%
close all
ATP_vals = [1e-2 1e-1 1 1 1 1];
AMP_vals = [0 0 0 1e-2 1e-1 1];
series_selection_original = [3 16 42 53 66 82];

% rng(9)
% series_selection_original = [randi([ 1 5]) ...
%                              randi([15 19]) ...
%                              randi([42 51]) ...
%                              randi([52 55]) ...
%                              randi([64 67]) ...
%                              randi([82 86])];

series_selection = series_selection_original;

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
%          "ATP/10uMATP_2.csv";                           % -180 -200 -212 -225
%          "ATP/100uMATP_1.csv";                          %      -200 -212 -225
%          "ATP/100uMATP_1.csv";                          %      -200 -212 -225
%          "AMP/1000uMATP+10uMAMP_2.csv";                 %           -210 -220 -235
%          "AMP/1000uMATP+100uMAMP_2.csv";                % -180 -205    -215   -230
%          "AMP/1000uMATP+1000uMAMP_1.csv";               %      -200    -215   -233 -245

% mu = reshape([-180 -200 -212 -225 -235;
%               -180 -200 -212 -225 -235;
%               -180 -200 -212 -225 -235;
%               -190 -210 -220 -235 -242;
%               -190 -210 -220 -230 -242;
%               -190 -210 -220 -235 -242], 1, []);

mu = mu_segments();
mu = reshape(mu(series_selection, :), 1, []);

lb_k = -ones(1, 16);
ub_k = 6*ones(1, 16);

lb_k = -ones(1, 16);
ub_k = 6*ones(1, 16);

lb_k(1)  = 1   ;
lb_k(9)  = 4 ;
lb_k(11) = 1   ;
lb_k(12) = 3   ;
lb_k(14) = 3   ;

ub_k(1)  = 4.75;
ub_k(3)  = -.3 ;
ub_k(4)  = 1.3 ;
ub_k(5)  = 3.75;
ub_k(6)  = 2.9 ;
ub_k(9)  = 4.5 ;
ub_k(11) = 1.5 ;
ub_k(13) = 1.5 ;
ub_k(15) = 3   ;
ub_k(16) = 4 ;

lb_c = repmat([1.5 -3], 1, 4);
ub_c = repmat([2.5 -1], 1, 4);

lb_mu = mu-5;
ub_mu = mu+5;

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
showQ(Qopt(:, :, 1), sprintf('Qopt (|ATP|=%.2f, |AMP|=%.2f)', ATP_vals(1), AMP_vals(1)), true)
nexttile
showQ(Qopt(:, :, end), sprintf('Qopt (|ATP|=%.2f, |AMP|=%.2f)', ATP_vals(end), AMP_vals(end)), true)

figure, hold on
semilogx(ATP_vals, [M_M1; M_M2]', ':')
semilogx(ATP_vals, [M1_M; M1_M2]', '-.')
semilogx(ATP_vals, [M2_M; M2_M1; M2_M3]', '--')
legend('M-M1', 'M-M2', 'M1-M', 'M1-M2', 'M2-M', 'M2-M1', 'M2-M3')
title('State change distributions w.r.t. |ADP|')
xlabel('|ADP| (mM)')
ylabel('fraction')
set(gca, 'XScale', 'log');
hold off

figure('WindowState', 'maximized')
b = bar(opts(:, [1:k_len k_len+mu_len+1:k_len+mu_len+5])', 'FaceColor', 'flat');
set(gca, 'XTick', [1:k_len+5])
set(gca, 'XTickLabel', {'k_1' 'k_2' 'k_3' 'k_4' 'k_5' 'k_6' 'k_7' 'k_8' ...
                        'k_9' 'k_{10}' 'k_{11}' 'k_{12}' 'k_{13}' 'k_{14}' 'k_{15}' 'k_{16}' ...
                        'c_1' 'c_2' 'c_3' 'c_4' 'c_5' 'c_6' 'c_7' 'c_8' ...
                        'sd_1' 'sd_2' 'sd_3' 'sd_4' 'sd_5'})
ylabel('log_1_0 optimum')
title('Optimum per initialization (winner highlighted)')
for i = 1:nstart, b(i).CData = b(1).CData; end
b(best).CData = repmat([0 0.8 0.8], size(b(best).CData, 1), 1);


%%
figure('WindowState', 'maximized')
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
    title(sprintf('(|ATP|, |AMP) = (%.3f, %.3f) mM', ...
                  ATP_vals(idx == series_selection), AMP_vals(idx == series_selection)));
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
    title(sprintf('(|ATP|, |AMP) = (%.3f, %.3f) mM', ...
                  ATP_vals(idx == series_selection), AMP_vals(idx == series_selection)));
    xlabel('time (sec)')
    ylabel('state (index)')
end


%%
closing_opening

ATP_vals = data.ATP(ATP_ind);
AMP_vals = data.AMP(AMP_ind);

figure
tiledlayout(1, 3)
nexttile
plot(ATP_vals, rates(:, 1))
title('LID closing')
xlabel('|ATP| (mM)')
ylabel('rate (sec^-^1)')

nexttile
plot(ATP_vals, rates(:, 2))
title('LID opening')
ylim([0, max(rates(:, 2:3), [], 'all')*1.2])
xlabel('|ATP| (mM)')
ylabel('rate (sec^-^1)')

nexttile
plot(AMP_vals, rates(1:end-1, 3))
title('LID opening')
ylim([0, max(rates(:, 2:3), [], 'all')*1.2])
xlabel('+|AMP| (mM)')
ylabel('rate (sec^-^1)')