function Q = Qmat(k, M)
    %    M0     M      Ma      M1     M1a     M2a    M2aa     M3aa
    Q = [0      k(17)  k(19)   k(21)  k(23)   0      0        0    ;        % 1: M0
         k(18)  0      k(1)*M  k(3)   0       0      0        0    ;        % 2: M
         k(20)  k(2)   0       0      k(5)    k(7)   0        0    ;        % 3: Ma
         k(22)  k(4)   0       0      k(9)*M  0      0        0    ;        % 4: M1
         k(24)  0      k(6)    k(10)  0       k(11)  0        0    ;        % 5: M1a
         0      0      k(8)    0      k(12)   0      k(13)*M  0    ;        % 6: M2a
         0      0      0       0      0       k(14)  0        k(15);        % 7: M2a
         0      0      0       0      0       0      k(16)    0    ];       % 8: M3aa
         
    Q = Q - diag(sum(Q, 2));
end