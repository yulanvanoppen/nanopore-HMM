M_ind = [1 12 20 23 28 31 36];
M_vals = data.M(M_ind);
dist = zeros(length(M_ind), 8);
Qopt = zeros(10, 10, length(M_ind));
Topt = zeros(10, 10, length(M_ind));
Trel = zeros(9, 9, length(M_ind));

M_M1 = zeros(1, length(M_vals));
M_M2 = zeros(1, length(M_vals));
M1_M = zeros(1, length(M_vals));
M1_M2 = zeros(1, length(M_vals));
M2_M = zeros(1, length(M_vals));
M2_M1 = zeros(1, length(M_vals));
M2_M3 = zeros(1, length(M_vals));

LID_closing = zeros(1, length(M_vals));
LID_opening = zeros(1, length(M_vals));

for idx = 1:length(M_ind)
    Qopt(:, :, idx) = Qmat(k_opt, M_vals(idx));
    Topt(:, :, idx) = eye(size(Qopt, 1)) + 2e-7*Qopt(:, :, idx);
    Trel(:, :, idx) = (Topt(2:end, 2:end, idx) - diag(diag(Topt(2:end, 2:end, idx)))) ...
                        ./ (1-diag(Topt(2:end, 2:end, idx)) - Topt(2:end, 1, idx));
                    
    stat_dist = asymptotics(dtmc(Topt(:, :, idx)));
    
    redist_M = [stat_dist(2:3) 0 0 0 0 0 0 0] * Trel(:, :, idx) / sum(stat_dist(2:3));
    redist_M = redist_M / sum(1 - sum(redist_M(1:2)));
    M_M1(idx) = sum(redist_M(3:4));
    M_M2(idx) = sum(redist_M(5:6));
    
    redist_M1 = [0 0 stat_dist(4:5) 0 0 0 0 0] * Trel(:, :, idx) / sum(stat_dist(4:5));
    redist_M1 = redist_M1 / sum(1 - sum(redist_M1(3:4)));
    M1_M(idx) = sum(redist_M1(1:2));
    M1_M2(idx) = sum(redist_M1(5:6));
    
    redist_M2 = [0 0 0 0 stat_dist(6:7) 0 0 0] * Trel(:, :, idx) / sum(stat_dist(6:7));
    redist_M2 = redist_M2 / sum(1 - sum(redist_M2(5:6)));
    M2_M(idx) = sum(redist_M2(1:2));
    M2_M1(idx) = sum(redist_M2(3:4));
    M2_M3(idx) = redist_M2(9);
end