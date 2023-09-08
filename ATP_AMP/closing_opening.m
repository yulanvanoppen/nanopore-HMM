rng('default')

ATP_ind = [3 10 11 16 21 36 42];

dwell_times_open = zeros(length(ATP_ind), 1);
dwell_times_closed1 = zeros(length(ATP_ind), 1);
dwell_times_closed2 = zeros(length(ATP_ind), 1);
parfor j = 1:length(ATP_ind)
    idx = ATP_ind(j);
    Qopt = Qmat((1-zero_ind).*k_opt, data.ATP(idx), 0);
    Gopt = abs(expm(dt*Qopt));
    mchain = dtmc(Gopt);
    C = simulate(mchain, 20*length(data.t{idx})-1, 'X0', [1 0 0 0 0 0 0 0 0 0]);

    state_open = ismember(C', [1:5 8:9]);
    enter_exit = find(diff([0, state_open, 0] == 1));
    counts = enter_exit(2:2:end) - enter_exit(1:2:end-1);
    dwell_times_open(j) = mean(counts*dt);

    state_closed = ismember(C', [6:7 10]);
    enter_exit = find(diff([0, state_closed, 0] == 1));
    counts = enter_exit(2:2:end) - enter_exit(1:2:end-1);
    dwell_times_closed1(j) = mean(counts*dt);
end

AMP_ind = [53 60 66 69 81 82];
parfor j = 1:length(AMP_ind)
    idx = AMP_ind(j);
    Qopt = Qmat((1-zero_ind).*k_opt, 1, data.AMP(idx));
    Gopt = abs(expm(dt*Qopt));
    mchain = dtmc(Gopt);
    C = simulate(mchain, 20*length(data.t{idx})-1, 'X0', [1 0 0 0 0 0 0 0 0 0]);

    state_closed = ismember(C', [6:7 10]);
    enter_exit = find(diff([0, state_closed, 0] == 1));
    counts = enter_exit(2:2:end) - enter_exit(1:2:end-1);
    dwell_times_closed2(j) = mean(counts*dt);
end

dwell_times = [dwell_times_open dwell_times_closed1 dwell_times_closed2];
rates = dwell_times.^-1;