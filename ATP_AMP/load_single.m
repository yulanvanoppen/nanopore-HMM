% Plot a single raw recording (for inspection)
file = "AMP/1000uMATP+1000uMAMP_2.csv";
subsample = 1;

raw = csvread(file, 2);
y = reshape(raw(:, 2:end), 1, []);
dt = raw(subsample+1, 1);
t = dt * (0:length(y)-1);

figure
plot(t, y)