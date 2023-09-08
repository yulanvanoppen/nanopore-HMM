rng('default')

series_selection = series_selection_original;
ATP_vals = data.ATP(series_selection);
AMP_vals = data.AMP(series_selection);

for idx = series_selection
    Qopt = Qmat((1-zero_ind).*k_opt, data.ATP(idx), data.AMP(idx));
    Gopt = abs(expm(dt*Qopt));
    mchain = dtmc(Gopt);
    C = simulate(mchain, length(data.t{idx})-1, 'X0', [1 0 0 0 0 0 0 0 0 0]);
    data.simulated_chain(idx) = {C-1};
    ATP = data.ATP(idx);
    AMP = data.AMP(idx);
    data.simulated_emission(idx) = {normrnd(mu_opt(ATP==ATP_vals & AMP==AMP_vals, C), sd_opt(C))};
end