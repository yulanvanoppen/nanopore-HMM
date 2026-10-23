function logL = likelihood(k, mu_all, sd, zero_ind, data)
%LIKELIHOOD log-likelihood of the ATP/AMP HMM for the selected time series.
%
%   k        - transition rates (24 elements, see QMAT)
%   mu_all   - emission means (6 concentration combinations x 5 levels)
%   sd       - emission standard deviations (5 levels)
%   zero_ind - indicator of rates that are removed from the model
%   data     - struct with fields ATP, AMP, t, y, w (one element per series)
%              and optionally Q_variant (see QMAT)
%
%   The forward algorithm is rescaled every five time points to prevent
%   under- or overflow. A quadratic penalty keeps the emission means close
%   to nominal current levels; removed rates are penalized heavily.

    if isfield(data, 'Q_variant'), variant = data.Q_variant; else, variant = "candidate"; end
    nseries = length(data.t);
    ATP_vals = [1e-2 1e-1 1 1 1 1];
    AMP_vals = [0 0 0 1e-2 1e-1 1];
    mu_all = reshape(mu_all, length(ATP_vals), []);

    logL = zeros(1, nseries);
    for idx = 1:nseries
        ATP = data.ATP(idx);
        AMP = data.AMP(idx);
        dt = data.t{idx}(2);
        y = data.y{idx};
        T = length(y);
        
        Q = Qmat((1-zero_ind).*k, ATP, max(1e-4, AMP), variant);
        G = abs(expm(dt*Q));
        mchain = dtmc(G);
        
        L = asymptotics(mchain);
        log_correct = 0;
        
        mu = mu_all(ATP==ATP_vals & AMP==AMP_vals, :);
        Lambda = normpdf(y', mu, sd);
        reorganized = Lambda(:, [1 2 2 3 3 4 4 2 3 5]);
        for t = 1:5:T-4
            L = ((((L * G .* reorganized(t, :)) ...
                      * G .* reorganized(t+1, :)) ...
                      * G .* reorganized(t+2, :)) ...
                      * G .* reorganized(t+3, :)) ...
                      * G .* reorganized(t+4, :);
            factor = 1/max(eps, min(L));
            L = L * factor;
            log_correct = log_correct - log(factor);
        end
        for t = T+1-mod(T, 5):T
            L = L * G .* reorganized(t, :);
            factor = 1/min(L);
            L = L * factor;
            log_correct = log_correct - log(factor);
        end

        logL(idx) = data.w(idx) * log(sum(L)) + log_correct ...
                    - sum((mu - [-185 -203 -215 -228 -239]).^2);
    end
    logL = -1e7*sum(zero_ind.*k) + sum(logL);
end