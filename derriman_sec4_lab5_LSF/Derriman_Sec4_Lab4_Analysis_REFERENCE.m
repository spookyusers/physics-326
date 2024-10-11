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
tbl_C = readtable('Sec4_lab4_C.txt');

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
disp(Nbar);

% Standard deviation of N
Sigma_N =  std(N_arr);
disp(Sigma_N);

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
title('Figure 2: Histogram of N for First Run')
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

Sigma_Nbar = std(means);
x = (mean(means)-6*Sigma_Nbar): Sigma_Nbar: (mean(means)+6*Sigma_Nbar);

% Get counts and centers
[counts, centers] = hist(means, x);

% Plot probability by normalizing counts by N_sample
figure()
color_hist = '#0072BD';
bar(centers, counts, 'EdgeColor', 'w', 'FaceColor', color_hist);
xlabel('Mean Counts ($\bar{N}$)', 'Interpreter', 'latex')
ylabel('Frequency', 'Interpreter', 'latex')
title('Figure 3: Histogram of $\bar{N}$ Small Bin Width', 'Interpreter', 'latex')
hold on

%-------------------------------------
% Plot Gaussian from 10min run on Small Bins  
%-------------------------------------
% Read data from the 10 minute run in part E
data_10min = readtable('sec4_lab4_E_10.txt');
rad_10min = data_10min.Radiation;

% Calculate the mean and standard deviation
Nbar_10min = mean(rad_10min);
sigma_N_10min = std(rad_10min);
n_10min = length(rad_10min);

% Standard deviation of mean
Sigma_Nbar_10min = sigma_N_10min / sqrt(n_10min);

% Define x for Gaussian
x_gauss = ( ...
    mean(means) - 6 * Sigma_Nbar) : ( ...
    Sigma_Nbar / 10) : (mean(means) + 6 * Sigma_Nbar);

% Calculate the Gaussian values
y_gauss = normpdf( ...
    x_gauss, Nbar_10min, Sigma_Nbar_10min) * (binWidth_small * N_runs);

% Plot Gaussian
plot(x_gauss, y_gauss, '-', 'Color', 'r')
legend( ...
    'Histogram of $\bar{N}$', ...
    'Gaussian from 10-min Run', 'Interpreter', 'latex')
hold off;

%%

% ---
% Histogram Coarse Bins
% ---

sigma_N_avg = mean(stds);

% Calculate bin width
bin_width_coarse = 2 * (sigma_N_avg / sqrt(60));

% Create bin edges centered around the mean of means
x = (mean(means) - 6*Sigma_Nbar) : bin_width_coarse :...
    (mean(means) + 6*Sigma_Nbar);

% Plot histogram
[counts, centers] = hist(means, x);

% Plotting
figure()
bar(centers, counts, 'EdgeColor', 'w', 'FaceColor', '#0072BD');
xlabel('Mean Counts ($\bar{N}$)', 'Interpreter', 'latex')
ylabel('Frequency', 'Interpreter', 'latex')
title('Figure 4: Histogram of $\bar{N}$ with Coarse Bin Width',...
    'Interpreter', 'latex')
hold on

% Plot Gaussian
y_norm = normpdf(centers, mean(means), Sigma_Nbar)...
    * (bin_width_coarse * N_runs);
plot(centers, y_norm, 'r-')

% Best estimate of R_0 using the mean of means
R_best = mean(means) / delta_t;

% Uncertainty in best estimate of decay rate
% Since we have N_runs independent, uncertainty decreases as 1/sqrt(N_runs)
Sigma_R = (Sigma_Nbar / delta_t);


% Calculate the percentage of Nbar values that fall within range
SigmaN_over_Sqrt_n = sigma_N_avg / sqrt(60);
N0 = mean(means);

% Prediction interval
lower_bound = N0 - SigmaN_over_Sqrt_n;
upper_bound = N0 + SigmaN_over_Sqrt_n;

% Count the number of means within the prediction interval
num_within_range = sum(means >= lower_bound & means <= upper_bound);

% Calculate the percentage
percentage_within_range = (num_within_range / N_runs) * 100;

% Display the result
fprintf( ...
    'Percentage of Mean N within N0 +/- sigma_N / sqrt(n): %.1f%%\n', ...
    percentage_within_range);


% Print results for best estimate and uncertainty
fprintf("Distribution of Mean N in 20 runs:\n")
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

% Title, legends
title( ...
    'Figure 6: Mean Count vs. Number of Data Points with Error Bars', 'FontSize', 14)
xlabel( ...
    'Number of Data Points (n)', 'FontSize', 12)
ylabel( ...
    'Mean Count ($\bar{N}$)', 'Interpreter', 'latex', 'FontSize', 12)

% Add legend
legend( ...
    'Data with Error Bars', 'Best Estimate $N_0$', ...
    'Interpreter', 'latex', 'Location', 'best')

% Adjust font sizes and line widths for better readability
set(gca, 'FontSize', 12)
set(gca, 'LineWidth', 1)


hold off
