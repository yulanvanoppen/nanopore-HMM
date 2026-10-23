function Q = Qmat(k, T, M, variant)
%QMAT generator matrix of the ATP/AMP adenylate kinase HMM.
%
%   Q = QMAT(k, T, M) returns the 10x10 transition rate matrix for rate
%   vector k (24 elements: k(1:16) between conformational/binding states,
%   k(17:24) to/from the M0 state), ATP concentration T, and AMP
%   concentration M (both in mM).
%
%   Q = QMAT(k, T, M, variant) selects the model topology:
%     "candidate" (default) - candidate configuration (same topology as the
%                     ADP model), used for the main results
%     "equal_rates" - alternative: candidate configuration with equal rates
%                     Ma <-> M2a and M2aa <-> Maa
%     "additional_transition" - alternative: candidate configuration with an
%         additional transition Ma -> Maa (rate k(9)*M) and Maa -> Ma (k(10))
%
%   States: 0 M0, 1 M, 2 Ma, 3 M1, 4 M1a, 5 M2a, 6 M2aa, 7 Maa, 8 M1aa, 9 M3aa
%   (MATLAB indices 1-10).

    if nargin < 4, variant = "candidate"; end

    switch string(variant)
        case "candidate"
            %  0 M0   1-M    2-Ma    3-M1   4-M1a   5-M2a  6-M2aa  7-Maa  8-M1aa  9-M3aa
            Q = [0      k(17)  k(19)   k(21)  k(23)   0      0       0      0       0    ;        % 0: M0
                 k(18)  0      k(1)*T  k(3)   0       0      0       0      0       0    ;        % 1: M
                 k(20)  k(2)   0       0      k(3)    k(5)   0       0      0       0    ;        % 2: Ma
                 k(22)  k(4)   0       0      k(1)*T  0      0       0      0       0    ;        % 3: M1
                 k(24)  0      k(4)    k(2)   0       k(7)   0       0      0       0    ;        % 4: M1a
                 0      0      k(6)    0      k(8)    0      k(9)*M  0      0       0    ;        % 5: M2a
                 0      0      0       0      0       k(10)  0       k(11)  k(13)   k(15);        % 6: M2aa
                 0      0      0       0      0       0      k(12)   0      0       0    ;        % 7: Maa
                 0      0      0       0      0       0      k(14)   0      0       0    ;        % 8: M1aa
                 0      0      0       0      0       0      k(16)   0      0       0    ];       % 9: M3aa

        case "equal_rates"
            %  0 M0   1-M    2-Ma    3-M1   4-M1a   5-M2a  6-M2aa  7-Maa  8-M1aa  9-M3aa
            Q = [0      k(17)  k(19)   k(21)  k(23)   0      0       0      0       0    ;        % 0: M0
                 k(18)  0      k(1)*T  k(3)   0       0      0       0      0       0    ;        % 1: M
                 k(20)  k(2)   0       0      k(3)    k(5)   0       0      0       0    ;        % 2: Ma
                 k(22)  k(4)   0       0      k(1)*T  0      0       0      0       0    ;        % 3: M1
                 k(24)  0      k(4)    k(2)   0       k(7)   0       0      0       0    ;        % 4: M1a
                 0      0      k(6)    0      k(8)    0      k(9)*M  0      0       0    ;        % 5: M2a
                 0      0      0       0      0       k(10)  0       k(6)   k(13)   k(15);        % 6: M2aa
                 0      0      0       0      0       0      k(5)    0      0       0    ;        % 7: Maa
                 0      0      0       0      0       0      k(14)   0      0       0    ;        % 8: M1aa
                 0      0      0       0      0       0      k(16)   0      0       0    ];       % 9: M3aa

        case "additional_transition"
            %  0 M0   1-M    2-Ma    3-M1   4-M1a   5-M2a  6-M2aa  7-Maa  8-M1aa  9-M3aa
            Q = [0      k(17)  k(19)   k(21)  k(23)   0      0       0      0       0    ;        % 0: M0
                 k(18)  0      k(1)*T  k(3)   0       0      0       0      0       0    ;        % 1: M
                 k(20)  k(2)   0       0      k(3)    k(5)   0       k(9)*M 0       0    ;        % 2: Ma
                 k(22)  k(4)   0       0      k(1)*T  0      0       0      0       0    ;        % 3: M1
                 k(24)  0      k(4)    k(2)   0       k(7)   0       0      0       0    ;        % 4: M1a
                 0      0      k(6)    0      k(8)    0      k(9)*M  0      0       0    ;        % 5: M2a
                 0      0      0       0      0       k(10)  0       k(11)  k(13)   k(15);        % 6: M2aa
                 0      0      k(10)   0      0       0      k(12)   0      0       0    ;        % 7: Maa
                 0      0      0       0      0       0      k(14)   0      0       0    ;        % 8: M1aa
                 0      0      0       0      0       0      k(16)   0      0       0    ];       % 9: M3aa

        otherwise
            error('Unknown Q-matrix variant "%s".', variant)
    end
    Q = Q - diag(sum(Q, 2));
end
