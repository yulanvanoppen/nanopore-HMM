%% Extract segments
fsATP = ["ATP/10uMATP_1.csv";                           % -180 -200 -212 -225 -235
         "ATP/10uMATP_2.csv";                           % -180 -200 -212 -225 -235
         "ATP/10uMATP_3.csv";                           % -180 -197 -213 -220 -235
         "ATP/20uMATP_1.csv";                           % -180 -198 -212 -220 -235
         "ATP/20uMATP_2.csv";                           % -180 -199 -210 -220 -235
         "ATP/20uMATP_3.csv";                           % -180 -200 -212 -225 -235
         "ATP/50uMATP_1.csv";                           % -190 -203 -214 -227 -235
         "ATP/50uMATP_2.csv";                           % -180 -199 -210 -220 -235
         "ATP/50uMATP_3.csv";                           % -180 -198 -221 -222 -235
         "ATP/100uMATP_1.csv";                          % -180 -200 -212 -225 -235
         "ATP/100uMATP_2.csv";                          % -180 -198 -211 -225 -235
         "ATP/100uMATP_3.csv";                          % -180 -199 -212 -226 -235
         "ATP/200uMATP_1.csv";                          % -185 -206 -215 -228 -235
         "ATP/200uMATP_2.csv";                          % -182 -198 -212 -223 -235
         "ATP/200uMATP_3.csv";                          % -180 -197 -212 -225 -235
         "ATP/500uMATP_1.csv";                          % -180 -197 -212 -224 -235
         "ATP/500uMATP_2.csv";                          % -180 -197 -212 -223 -235
         "ATP/500uMATP_3.csv";                          % -190 -200 -212 -225 -235
         "ATP/1000uMATP_1.csv";                         % -180 -200 -212 -225 -235
         "ATP/1000uMATP_2.csv";                         % -180 -197 -212 -225 -235
         "ATP/1000uMATP_3.csv"];                        % -180 -199 -210 -225 -235
     
fsAMP = ["AMP/1000uMATP+10uMAMP_1.csv";                 % -180 -199 -213 -225 -235
         "AMP/1000uMATP+10uMAMP_2.csv";                 % -188 -200 -210 -226 -240
         "AMP/1000uMATP+10uMAMP_3.csv";                 % -189 -208 -220 -233 -240
         "AMP/1000uMATP+50uMAMP_1.csv";                 % -191 -209 -222 -235 -243
         "AMP/1000uMATP+50uMAMP_2.csv";                 % -185 -206 -222 -235 -245
         "AMP/1000uMATP+50uMAMP_3.csv";                 % -187 -210 -218 -234 -244
         "AMP/1000uMATP+100uMAMP_1.csv";                % -188 -211 -222 -233 -241
         "AMP/1000uMATP+100uMAMP_2.csv";                % -184 -206 -217 -230 -242
         "AMP/1000uMATP+100uMAMP_3.csv";                % -187 -205 -220 -230 -246
         "AMP/1000uMATP+200uMAMP_1.csv";                % -184 -208 -220 -233 -244
         "AMP/1000uMATP+200uMAMP_2.csv";                % -193 -211 -220 -233 -245
         "AMP/1000uMATP+200uMAMP_3.csv";                % -193 -210 -220 -234 -245
         "AMP/1000uMATP+500uMAMP_1.csv";                % -189 -209 -220 -234 -247
         "AMP/1000uMATP+500uMAMP_2.csv";                % -193 -211 -220 -233 -247
         "AMP/1000uMATP+500uMAMP_3.csv";                % -190 -207 -222 -237 -250
         "AMP/1000uMATP+1000uMAMP_1.csv";               % -181 -208 -220 -233 -242***
         "AMP/1000uMATP+1000uMAMP_2.csv";               % -193 -208 -222 -232 -250
         "AMP/1000uMATP+1000uMAMP_3.csv";               % -193 -212 -220 -233 -246
         "AMP/1000uMATP+1000uMAMP_4.csv"];             % -193 -208 -220 -232 -245***
     
files = [fsATP; fsAMP];
% files = fsATP;
% files = fsAMP;
                                        
segments = {[0.020  2.390];                             % 10uMATP_1 (1)
            [0.025  1.860;  1.205  8.550];              % 10uMATP_2 (2-3)
            [0.035  0.355;  0.515  2.300];              % 10uMATP_3   (4-5)
            [0.120  2.310;  2.320  4.005];              % 20uMATP_1   (6-7)
            [0.040  0.510;  0.525  3.495];              % 20uMATP_2   (8-9)
            [0.075  8.535];                             % 20uMATP_3   (10)
            [0.060  4.040];                             % 50uMATP_1   (11)
            [0.045  2.245;  2.270  3.100];              % 50uMATP_2   (12-13)
            [0.045  2.895];                             % 50uMATP_3   (14)
            [0.050  2.285;  2.365  6.135];              % 100uMATP_1  (15-16)
            [0.035  3.710];                             % 100uMATP_2  (17)
            [0.010  0.970;  1.035  1.400];              % 100uMATP_3  (18-19)
            [0.030  3.210;  3.350  8.285];              % 200uMATP_1  (20-21)
            [0.005  1.150;  1.455  6.105];              % 200uMATP_2  (22-23)
            [0.140  0.820;  0.840  4.005;               % 200uMATP_3  (24-27)
             4.025  4.460;  4.590  8.305];
            [0.115  1.265;  1.275  3.305;               % 500uMATP_1  (28-30)
             3.345  3.530];
            [0.035  1.005;  1.035  1.985;  2.005  2.830;% 500uMATP_2  (31-35)
             2.835  3.830;  3.865  4.560];
            [0.030  4.640;  4.660  6.050;  6.135  8.025;% 500uMATP_3  (36-41)
             8.095  8.930;  8.980  9.555;  9.820 10.745];
            [0.055  4.970;  5.030  5.415;               % 1000uMATP_1 (42-44)
             5.555  6.015];
            [0.090  0.380;  0.395  2.425];              % 1000uMATP_2 (45-46)
            [0.000  0.955;  1.015  1.585;  1.685  2.240;% 1000uMATP_3 (47-51)
             2.255  2.595;  2.600  2.915]; 
             
            [0.050  2.355];                             % 10uMAMP_1   (52)
            [0.030  3.625];                             % 10uMAMP_2   (53)
            [0.090  2.685;  2.825  4.325];              % 10uMAMP_3   (54-55)
            [0.105  1.700;  1.850  5.465];              % 50uMAMP_1   (56-57)
            [0.035  0.410;  0.435  1.880;               % 50uMAMP_2   (58-60)
             2.080  6.005];
            [0.025  1.030;  1.215  2.405;               % 50uMAMP_3   (61-63)
             3.225  6.835];
            [0.060  0.325;  0.855  3.135];              % 100uMAMP_1  (64-65)
            [0.060  9.985];                             % 100uMAMP_2  (66)
            [0.055  4.040];                             % 100uMAMP_3  (67)

            [0.570  1.700;  1.960  6.335;               % 200uMAMP_1  (68-70)
             6.365  7.245];
            [0.145  1.270;  1.280  1.730;  1.775  5.945;% 200uMAMP_2  (71-75)
             5.960  8.330;  8.340  8.870];
            [0.110  2.445];                             % 200uMAMP_3  (76)
            [0.050  1.785;  1.795  2.755;               % 500uMAMP_1  (77-79)
             2.925  7.750];
            [0.035  2.940];                             % 500uMAMP_2  (80)
            [0.080  6.425];                             % 500uMAMP_3  (81)
            [0.010  2.030;  2.045  2.460];              % 1000uMATP_1 (82-83)
            [0.040  1.965];                             % 1000uMATP_2 (84)
            [0.035  1.590];                             % 1000uMATP_3 (85)
            [0.050  1.335];                             % 1000uMATP_4 (86)
            };


%% Process concentration-weights for segments
lengths = cellfun(@(x) size(x, 1), segments)';
segment_lengths = cell2mat(cellfun(@(x) diff(x, 1, 2), segments, ...
                           'UniformOutput', false));
seg_file_indices = arrayfun(@(idx) repmat(idx, 1, lengths(idx)), 1:length(files), ...
                            'UniformOutput', false);
seg_file_indices = cell2mat(seg_file_indices);

mMATP = str2double(regexp(files, '[0-9]+(?=uMATP)', 'match', 'once')) / 1000;
mMAMP = str2double(regexp(files, '[0-9]+(?=uMAMP)', 'match', 'once')) / 1000;
mMAMP(isnan(mMAMP)) = 0;
mM = [mMATP mMAMP];

[~, ~, ix] = unique(mM, 'rows');
repetitions = accumarray(ix, 1)';
group_indices = [0 cumsum(repetitions)];
weights = cell2mat(cellfun(@(x) sum(diff(x, 1, 2)), segments, ...
                   'UniformOutput', false))';

denominators = arrayfun(@(idx) repelem(sum(weights(group_indices(idx)+1:group_indices(idx+1))), ...
                                       repetitions(idx)), ...
                        1:length(repetitions), 'UniformOutput', false);
weights = repelem(1./cell2mat(denominators).^2, lengths);


%% Sort into struct
subsample = 1;

nfiles = length(files);
nseries = 0;
data = struct();
for idx = 1:nfiles
    raw = csvread(files(idx), 2);
    
    y = reshape(raw(:, 2:end), 1, []);
    y = y(1:subsample:end);
    dt = raw(subsample+1, 1);
    t = dt * (0:length(y)-1);
    
    nsegments = size(segments{idx}, 1);
    for subidx = 1:nsegments
        segment = segments{idx}(subidx, 1) <= t & t <= segments{idx}(subidx, 2);
        data.ATP(nseries+subidx) = mMATP(idx);
        data.AMP(nseries+subidx) = mMAMP(idx);
        data.t(nseries+subidx) = {t(1:sum(segment))};
        data.y(nseries+subidx) = {y(segment)};
        data.w(nseries+subidx) = weights(nseries+subidx);
    end
    nseries = nseries + nsegments;
end