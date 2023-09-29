rng('default')

for idx = series_selection
    Qopt = Qmat((1-zero_ind).*k_opt, data.ADP(idx));
    Gopt = abs(expm(dt*Qopt));
    mchain = dtmc(Gopt);
    C = simulate(mchain, length(data.t{idx})-1, 'X0', [1 0 0 0 0 0 0 0 0 0]);
    data.simulated_chain(idx) = {C-1};
    if size(mu_opt, 1) == 1
        data.simulated_emission(idx) = {normrnd(mu_opt(C), sd_opt(C))};
    else
        data.simulated_emission(idx) = {normrnd(mu_opt(data.ADP(idx)==ADP_values, C), sd_opt(C))};
    end
end