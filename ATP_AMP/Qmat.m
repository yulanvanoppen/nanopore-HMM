% UNCOMMENT Q-MATRIX OF INTEREST

% % Candidate configuration
% function Q = Qmat(k, T, M)
%     %  0 M0   1-M    2-Ma    3-M1   4-M1a   5-M2a  6-M2aa  7-Maa  8-M1aa  9-M3aa
%     Q = [0      k(17)  k(19)   k(21)  k(23)   0      0       0      0       0    ;        % 0: M0
%          k(18)  0      k(1)*T  k(3)   0       0      0       0      0       0    ;        % 1: M
%          k(20)  k(2)   0       0      k(3)    k(5)   0       0      0       0    ;        % 2: Ma
%          k(22)  k(4)   0       0      k(1)*T  0      0       0      0       0    ;        % 3: M1
%          k(24)  0      k(4)    k(2)   0       k(7)   0       0      0       0    ;        % 4: M1a
%          0      0      k(6)    0      k(8)    0      k(9)*M  0      0       0    ;        % 5: M2a
%          0      0      0       0      0       k(10)  0       k(11)  k(13)   k(15);        % 6: M2aa
%          0      0      0       0      0       0      k(12)   0      0       0    ;        % 7: Maa
%          0      0      0       0      0       0      k(14)   0      0       0    ;        % 8: M1aa
%          0      0      0       0      0       0      k(16)   0      0       0    ];       % 9: M3aa
%     Q = Q - diag(sum(Q, 2));
% end

% % Alternative: Equal rates Ma <-> M2a and M2aa <-> Maa
% function Q = Qmat(k, T, M)
%     %  0 M0   1-M    2-Ma    3-M1   4-M1a   5-M2a  6-M2aa  7-Maa  8-M1aa  9-M3aa
%     Q = [0      k(17)  k(19)   k(21)  k(23)   0      0       0      0       0    ;        % 0: M0
%          k(18)  0      k(1)*T  k(3)   0       0      0       0      0       0    ;        % 1: M
%          k(20)  k(2)   0       0      k(3)    k(5)   0       0      0       0    ;        % 2: Ma
%          k(22)  k(4)   0       0      k(1)*T  0      0       0      0       0    ;        % 3: M1
%          k(24)  0      k(4)    k(2)   0       k(7)   0       0      0       0    ;        % 4: M1a
%          0      0      k(6)    0      k(8)    0      k(9)*M  0      0       0    ;        % 5: M2a
%          0      0      0       0      0       k(10)  0       k(6)   k(13)   k(15);        % 6: M2aa
%          0      0      0       0      0       0      k(5)    0      0       0    ;        % 7: Maa
%          0      0      0       0      0       0      k(14)   0      0       0    ;        % 8: M1aa
%          0      0      0       0      0       0      k(16)   0      0       0    ];       % 9: M3aa
%     Q = Q - diag(sum(Q, 2));
% end

% Alternative: Additional transition Ma -> Maa
function Q = Qmat(k, T, M)
    %  0 M0   1-M    2-Ma    3-M1   4-M1a   5-M2a  6-M2aa  7-Maa  8-M1aa  9-M3aa
    Q = [0      k(17)  k(19)   k(21)  k(23)   0      0       0      0       0    ;        % 0: M0
         k(18)  0      k(1)*T  k(3)   0       0      0       k(9)*M 0       0    ;        % 1: M
         k(20)  k(2)   0       0      k(3)    k(5)   0       0      0       0    ;        % 2: Ma
         k(22)  k(4)   0       0      k(1)*T  0      0       0      0       0    ;        % 3: M1
         k(24)  0      k(4)    k(2)   0       k(7)   0       0      0       0    ;        % 4: M1a
         0      0      k(6)    0      k(8)    0      k(9)*M  0      0       0    ;        % 5: M2a
         0      0      0       0      0       k(10)  0       k(11)  k(13)   k(15);        % 6: M2aa
         0      0      k(10)   0      0       0      k(12)   0      0       0    ;        % 7: Maa
         0      0      0       0      0       0      k(14)   0      0       0    ;        % 8: M1aa
         0      0      0       0      0       0      k(16)   0      0       0    ];       % 9: M3aa
    Q = Q - diag(sum(Q, 2));
end