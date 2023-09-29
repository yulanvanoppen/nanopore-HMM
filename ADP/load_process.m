%% Extract usable segments
files = ["ADP/10uM_ADP_1.csv";
         "ADP/10uM_ADP_2.csv";
         "ADP/10uM_ADP_3.csv";
         "ADP/10uM_ADP_4.csv";
         "ADP/20uM_ADP_1.csv";
         "ADP/20uM_ADP_2.csv";
         "ADP/20uM_ADP_3.csv";
         "ADP/20uM_ADP_4.csv";
         "ADP/50uMADP_2.csv";
         "ADP/50uMADP_3.csv";
         "ADP/100uMADP_1.csv";
         "ADP/100uMADP_2.csv";
         "ADP/100uMADP_3.csv";
         "ADP/200uMADP_1.csv";
         "ADP/200uMADP_2.csv";
         "ADP/200uMADP_3.csv";
         "ADP/500uMADP_1.csv";
         "ADP/500uMADP_2.csv";
         "ADP/500uMADP_3.csv";
         "ADP/1000uMADP_1.csv";
         "ADP/1000uMADP_2.csv";
         "ADP/1000uMADP_3.csv";
         "ADP/1000uMADP_4.csv"];
                                        
segments = {[0.0075  1.1305;  1.3500  4.3550];
            [0.0265  1.8605;  1.8620  4.6700];
            [0.1020  5.7800;  5.7840  8.0760;
             8.0765 11.4810];
            [0.0380  0.3140;  0.3210  4.0450;
             4.0945  4.6835;  4.6845  5.8500];
            [0.0005  1.0950;  1.1170  1.6800;
             1.6940  4.0550;  4.0605  4.8660];
            [0.0210  0.5200;  0.5955  4.1720];
            [0.0485  2.4950];
            [0.0215  2.9600];
            [0.0465  1.3035;  1.3825  4.9400];
            [0.0535  1.0815];
            [0.0130  0.4170;  0.4175  2.5075];
            [0.0090  0.7595];
            [0.0100  0.6535;  0.6620  1.4315];
            [0.0280  1.4625];
            [0.0205  0.9240];
            [0.0480  0.5945];
            [0.0125  0.2265;  0.2270  1.0550];
            [0.0700  0.6035];
            [0.0345  0.2320;  0.3600  0.7115];
            [0.0415  0.6480];
            [0.0185  1.2225];
            [0.0680  0.5495];
            [0.0340  0.3510]};


%% Process concentration-weights for segments
lengths = cellfun(@(x) size(x, 1), segments)';
segment_lengths = cell2mat(cellfun(@(x) diff(x, 1, 2), segments, ...
                           'UniformOutput', false));
repetitions = arrayfun(@(idx) repmat(idx, 1, lengths(idx)), 1:length(files), ...
                       'UniformOutput', false);
seg_file_indices = cell2mat(repetitions);
weights = cell2mat(cellfun(@(x) sum(diff(x, 1, 2)), segments, ...
                   'UniformOutput', false));
weights = 1./[repelem(sum(weights(1:4)), 4) repelem(sum(weights(5:8)), 4) ...
              repelem(sum(weights(9:10)), 2) repelem(sum(weights(11:13)), 3) ...
              repelem(sum(weights(14:16)), 3) repelem(sum(weights(17:19)), 3) ...
              repelem(sum(weights(20:23)), 4)].^2;
weights = repelem(weights, lengths);


%% Sort into struct
subsample = 1;

nfiles = length(files);
nseries = 0;
data = struct();
for idx = 1:nfiles
    raw = csvread(files(idx), 2);
    
    ADP = str2double(regexp(files(idx), '[0-9]+', 'match', 'once')) / 1000;
    y = reshape(raw(:, 2:end), 1, []);
    y = y(1:subsample:end);
    dt = raw(subsample+1, 1);
    t = dt * (0:length(y)-1);
    
    nsegments = size(segments{idx}, 1);
    for subidx = 1:nsegments
        segment = segments{idx}(subidx, 1) <= t & t <= segments{idx}(subidx, 2);
        data.ADP(nseries+subidx) = ADP;
        data.t(nseries+subidx) = {t(1:sum(segment))};
        data.y(nseries+subidx) = {y(segment)};
        data.w(nseries+subidx) = weights(nseries+subidx);
        if max(y(segment) > -100)
            disp(1)
        end
    end
    nseries = nseries + nsegments;
end