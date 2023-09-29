rng('default')

dwell_times = zeros(length(series_selection), 2);
for idx = series_selection
    Qopt = Qmat((1-zero_ind).*k_opt, data.ADP(idx));
    Gopt = abs(expm(dt*Qopt));
    mchain = dtmc(Gopt);
    C = simulate(mchain, 1000000, 'X0', [1 0 0 0 0 0 0 0 0 0]);

    state_open = ismember(C', [1:5 8:9]);
    enter_exit = find(diff([0, state_open, 0] == 1));
    counts = enter_exit(2:2:end) - enter_exit(1:2:end-1);
    dwell_times(idx == series_selection, 1) = mean(counts*dt);

    state_closed = ismember(C', [6:7 10]);
    enter_exit = find(diff([0, state_closed, 0] == 1));
    counts = enter_exit(2:2:end) - enter_exit(1:2:end-1);
    dwell_times(idx == series_selection, 2) = mean(counts*dt);
end

rates = dwell_times.^-1;