%%
% Lab 4: Distributed Functions (2)
% Kym Derriman (Partner Diego Juarez)
% Date: 10/3/2024
%-----------------------------------

%%
%-----
% Part C: Study distribution of N in one run.
%-----

% Import and extract data as table from text file
tbl_C = readtable('Sec4_Lab4_C.txt');

% Extract 'Time' column data and assign it to an array
T_arr = tbl_C.Time;  

% Extract 'Radiation' column data and assign it to an array
N_arr = tbl_C.Radiation; 

% Time interval (i.e., exposure of detector) for a single acquision of radiation counts (in seconds)
delta_t = 0.5;

% Total time for a run
sample_t = 30;

% Number of single acquisitions of radiation counts (30 s / 0.5 s)
num_data = sample_t / delta_t;

% Mean of decay events per sample
Nbar =  mean(N_arr);

% Standard deviation of N
Sigma_N =  std(N_arr);

% Best estimate of the true value of the decay rate R_0
R_best = Nbar / delta_t;

% Uncertainty in best estimate of decay rate
Sigma_R = (Sigma_N / delta_t) / sqrt(num_data);

% ---
% Part C Results:
% ---

% Print results for best estimate and uncertainty first run
fprintf("Distribution of N in one run:\n")
fprintf("Best estimate R_0 = %10.2f ± %10.2f counts/s\n", R_best, Sigma_R)

%-------------------------------------
% Plot histogram
%-------------------------------------
x = min(N_arr):max(N_arr);

% Get counts and centers
[counts, centers] = hist(N_arr, x);

% Plot probability by normalizing counts by N_sample
color_hist = '#0072BD';
bar(centers, counts/num_data, 'EdgeColor', 'w', 'FaceColor', color_hist);
xlabel('Number of Counts (N)')
ylabel('Frequency')
title('Histogram of N for First Run')
hold on

%-------------------------------------
% Plot Gaussian distribution  
%-------------------------------------
%y_norm = normpdf(x, Nbar, Sigma_N);

%color_norm = 'r';
%plot(x, y_norm, '-', 'Color', color_norm)

%  Does the histogram resemble a Gaussian curve centered on Nbar?
%  Is the standard deviation as expected?

%%
% ---
% Part D: Study the distribution of Nbar in a set of runs. Repeat part C 
% experiment (30 seconds) 20 times, recording Nbar and Sigma_N each time.
% ---

% Time interval (i.e., exposure of detector) for a single acquision of 
% radiation counts (in seconds)
delta_t = 0.5;

means = [];
stds = [];
radiations = [];
filename.Temp = "sec4_lab4_D_%d.txt";
N_runs = 20;

for i = 1:N_runs
    data = readtable(sprintf(filename.Temp, i));
    rad = data.Radiation;
    means = [means, mean(rad)];
    stds = [stds, std(rad)];
    radiations = [radiations, rad];
end


%-------------------------------------
% Plot histogram Small Bins
%-------------------------------------

%binWidth_small = 1;
%Sigma_Nbar = sqrt(sum(stds.^2)) / sqrt(length(means));
Sigma_Nbar = std(means);
x = (mean(means)-6*Sigma_Nbar): Sigma_Nbar: (mean(means)+6*Sigma_Nbar);

% Get counts and centers
[counts, centers] = hist(means, x);

% Plot probability by normalizing counts by N_sample
figure()
color_hist = '#0072BD';
bar(centers, counts/N_runs, 'EdgeColor', 'w', 'FaceColor', color_hist);
xlabel('Number of Counts (N)')
ylabel('Frequency')
title('Small Bins Histogram')
hold on

%-------------------------------------
% Plot Gaussian Small Bins  
%-------------------------------------
y_norm = normpdf(x, mean(means), std(stds));

color_norm = 'r';
plot(x, y_norm, '-', 'Color', color_norm)

% ---
% Histogram Coarse Bins
% ---

Two_Sigma_Nbar = 2 * Sigma_Nbar;
x = (mean(means)-6*Two_Sigma_Nbar) :Two_Sigma_Nbar: (mean(means)+6*Two_Sigma_Nbar);


% Get counts and centers
[counts, centers] = hist(rad, x);

% Plot probability by normalizing counts by N_sample
figure()
color_hist = '#0072BD';
bar(centers, counts/N_runs, 'EdgeColor', 'w', 'FaceColor', color_hist);
xlabel('')
ylabel('')
title('Coarse Bins Histogram')
hold on
hold off

% Print updated best estimate of R_0
R_best = mean(rad) / delta_t;

% Uncertainty in best estimate of decay rate
Sigma_R = (Sigma_Nbar / delta_t) / sqrt(N_runs);

% Print results for best estimate and uncertainty first run
fprintf("Distribution of Nbar in 20 runs:\n")
fprintf("Best estimate R_0 = %10.2f ± %10.2f counts/s\n", R_best, Sigma_R)
%%
%-------------------------------------
% Part E: Study the variation in both the mean and the standard deviation
% of the man as the run length (sample size) varies.

% Array of different acquisition times (in second)
T_data_arr = [1, 2, 4, 8, 15, 30, 60, 120, 300, 600];

means = [];
stds = [];
radiations = [];
Nbar_array = [];
filename.Temp = "sec4_lab4_E_%d.txt";
N_runs = length(T_data_arr);

for i = 1:N_runs
    data = readtable(sprintf(filename.Temp, i));
    rad = data.Radiation;
    means = [means, mean(rad)];
    stds = [stds, std(rad)];
    
end

% Number of data for each acquisition time
num_data_arr = T_data_arr /delta_t;	

% Standard deviation of mean radiation counts (Nbar) for each acqusition time  
Sigma_Nbar_arr = stds ./ sqrt(num_data_arr);

%-------------------------------------
% Plotting
%-------------------------------------
% 1. Plot Nbar vs Sigma_Nbar

% x-axis data 
X_arr = num_data_arr;

% y-axis data
Y_arr = means; 

% error bar data
E_arr = Sigma_Nbar_arr; 

% Plot error bars
errorbar(X_arr,Y_arr, E_arr, 'o')

% Show x-axis in log scale
set(gca, 'Xscale', 'log');

% Adjust x-axis limit 
xlim([min(X_arr)/1.2, max(X_arr)*1.2])

% 2. Show the best estimate of Nbar, corresponding to the case of largest number of data points

% Get the best Nbar estimate value
Nbar_best =  means(end-1); 

% Construct an horizontal line of the best Nbar estimate
Nbar_best_arr = Nbar_best*ones(size(X_arr));

% Overlay this horizontal reference line with the error bar plot
hold on

plot(X_arr, Nbar_best_arr, '-r') 

hold off

%-------------------------------------
% Format figure for better visibility 
%-------------------------------------
% 'formatfig' is a custom Matlab function written by Prof. Sang-Hyuk Lee.
% It is uploaded to Canvas too. Make sure you download it to the same folder where your script is located
% in order to use it.
% formatfig(gcf, 'line', 'stretch',[0.9, 0.9])
% 
% % Remove plot box
% box('off')
% 
% % Figure title
% title('$\bar{N} (n) \pm \sigma_{\bar{N}} (= \sigma/\sqrt{n})$', 'FontSize', 16, 'Interpreter', 'latex');
% 
% % Label x and y axis
% xlabel('Number of data points (n)', 'FontSize', 16);
% ylabel('Mean Radiation Count', 'FontSize', 16);
% 
% 
% % Adjust axis width to show the full title
% pos_old = get(gca, 'Position');
% pos_new = [pos_old(1:3), 0.72];
% set(gca, 'Position', pos_new);
% 
