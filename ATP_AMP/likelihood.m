function logL = likelihood(k, mu_all, sd, zero_ind, data)
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
        
        Q = Qmat((1-zero_ind).*k, ATP, max(1e-4, AMP));
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