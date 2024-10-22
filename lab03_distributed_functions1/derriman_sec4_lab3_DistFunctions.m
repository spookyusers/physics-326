%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lab 3: Distribution Functions
% Name: Kym Derriman
% Date 09/26/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
% First Run (30 seconds):
%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------
% Data Import and Analysis
%----------------------------

% Read a text file as a Matlab table
tbl1 = readtable('sec4_lab3_30.txt');

% Extract 'Time' column data and assign it to an array 
t1 = tbl1.Time;

% Extract 'Radiation' column data and assign it to an array
c1 = tbl1.Radiation; 

%--------------------
% Print Results
%--------------------

% Plot histogram with fixed bin width of 5 counts
figure;
results = histoGauss(c1);
%saveas(gcf, 'fig1.png')

% Print results first run
fprintf("\nFirst Run (30 seconds):\n")
fprintf("Best estimate R_0 = %10.2f ± %10.2f counts/s\n", results.best, results.sigmaR)




%%

%%%%%%%%%%%%%%%%%%%%%%%%%
% Second Run (5 minutes):
%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------
% Data Import and Analysis
%----------------------------

% Read a text file as a Matlab table
tbl2 = readtable('sec4_lab3_300.txt');

% Extract 'Radiation' column data and assign it to an array 
c2 = tbl2.Radiation; 

%--------------------
% Print Results
%--------------------

% Plot histogram with bin width as 2 * Sigma_N
figure;
results = histoGauss(c2);
%saveas(gcf, 'fig2.png')

% Print results second run
fprintf("\nSecond Run (5 minutes):\n")
fprintf("Best estimate R_0 = %10.2f ± %10.2f counts/s\n", results.best, results.sigmaR)


%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Coarse-grained histogram of 2 * sigma
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot histogram with bin width as 2 * Sigma_N
figure;
results = histoGauss(c2, 'UseSigmaMultiplier', true, ...
    'BinWidthMultiplier', 2);
%saveas(gcf, 'fig3.png')

% Calculate the percentage of counts in the central bin

% Calculate the mean of the data
mean_val = mean(c2);

% Make a vector for centers then find minimum
[~, centralIdx] = min(abs(results.centers - mean_val));

% Get center bin counts
central_count = results.counts(centralIdx);
% Sum counts whole set of bins
total_counts = sum(results.counts);
% Get percentage center bin
percentage_central = (central_count / total_counts) * 100;

% Print the percentage
fprintf( ...
    "Percentage of counts in the central bin: %.2f%%\n", ...
    percentage_central)




%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compare large N sample with expected distribution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------
% Data Import and Analysis
%----------------------------

% Read a text file as a Matlab table
tbl3 = readtable('sec4_lab3_600.txt');

% Extract 'Radiation' column data and assign it to an array 
c3 = tbl3.Radiation; 

%--------------------
% Print Results
%--------------------

% Plot histogram
figure;
results = histoGauss(c3, 'binWidth',1);
%saveas(gcf, 'fig4.png')

% Print results third run
fprintf("\nThird Run (10 minutes):\n")
fprintf("Best estimate R_0 = %10.2f ± %10.2f counts/s\n", results.best, results.sigmaR)

%----- 
% Calculate Percentages Within 1, 2, and 3 multiples of sigma
%-----

total_counts = sum(results.counts);
mu = mean(c3); 
sigma = std(c3);

% Define the sigma intervals and make an array for the percents
intervals = [1, 2, 3];
percentages = zeros(length(intervals), 1);

% Loop through each interval to calculate percentages
for i = 1:length(intervals)
    current_sigma = intervals(i) * sigma;
    
    % Define lower and upper bounds
    lower_bound = mu - current_sigma;
    upper_bound = mu + current_sigma;
    
    % Count data points within the interval
    count_within = sum(c3 >= lower_bound & c3 <= upper_bound);
    
    % Calculate percentage
    percentages(i) = (count_within / total_counts) * 100;
end

%----- 
% Create the Table
%-----

% Define table variables
sigma_levels = {'+/- sigma'; '+/- 2sigma'; '+/- 3sigma'};
percentages_table = table(sigma_levels, percentages, ...
    'VariableNames', {'Sigma_Level', 'Percentage'});

% Define theoretical percentages for normal distribution
theoretical_percentages = [68.27; 95.45; 99.73];

% Create a comparison table
comparison_table = table(sigma_levels, percentages, theoretical_percentages, ...
    'VariableNames', {'Sigma_Level', 'Empirical_Percentage', 'Theoretical_Percentage'});

% Display the comparison table and save as excel
disp(comparison_table)
%writetable(comparison_table, 'sigma_percentages_comparison.xlsx')




%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Poisson distribution
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Import data and extract radiation numbers
tbl4 = readtable('sec4_lab3_partF.txt');
c4 = tbl4.Radiation; 

% Define bin width, edges, counts, etc
binWidth = 1;
min_val = floor(min(c4));
max_val = ceil(max(c4));
bin_edges = min_val:binWidth:max_val + binWidth;
counts = histcounts(c4, bin_edges);
centers = bin_edges(1:end-1) + binWidth/2;

% Normalize counts to get probabilities
probabilities = counts / sum(counts);

% Plot the histogram
figure;
bar(centers, probabilities, 'EdgeColor', 'w', 'FaceColor', '#0072BD');
xlabel('Number of Counts per 1/20s Interval');
ylabel('Probability');
title('Experimental Distribution of Counts (1 Minute Run)');
hold on;

% Calculate the mean number of counts
lambda = mean(c4);

fprintf("Calculated Mean (lambda) = %.2f counts/interval\n", lambda);

% Generate the Poisson with the lambda above
k = min(c4):max(c4);

% Calculate Poisson probabilities
poisson_probs = poisspdf(k, lambda);

% Plot theory distrubution with legend and markers
plot(k, poisson_probs, 'r-', 'LineWidth', 2);
legend('Experimental Data', 'Theoretical Poisson Distribution');
hold off;
%saveas(gcf, 'fig5.png')



%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Series of runs as N_best varies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of runs and filenames
num_runs = 3;
run_filenames = {'sec4_lab3_partG_A.txt', 'sec4_lab3_partG_B.txt', 'sec4_lab3_partG_C.txt'};

% Initialize array to store means
lambda_means = zeros(num_runs,1);

% Create tiled layout for subplots
tiledlayout(1, num_runs, 'TileSpacing', 'Compact', 'Padding', 'Compact');

% Initialize variables for legend
legendHandles = [];
legendLabels = {'Experimental Data', 'Theoretical Poisson'};

% Loop through each run to get data and analyze
for i = 1:num_runs
    
    % Get data and make vector for the radiation counts
    tbl = readtable(run_filenames{i});
    rad = tbl.Radiation; 
    
    % Calculate mean (lambda) and standard deviation (sigmaN)
    lambda_means(i) = mean(rad);
    
    % Create subplot
    nexttile;
    
    % Define bin width and edges
    binWidth = 1;
    min_val = floor(min(rad));
    max_val = ceil(max(rad));
    bin_edges = min_val : binWidth : max_val + binWidth;
    centers = bin_edges(1: end-1) + binWidth/2;
    
    % Calculate histogram counts and probabilities
    hist_counts = histcounts(rad, bin_edges);
    probabilities = hist_counts / sum(hist_counts);
    
    % Plot the histogram as a bar graph
    hBar = bar(centers, probabilities, 'EdgeColor', 'w', 'FaceColor', '#0072BD');
    hold on;
    
    % Plot the theoretical Poisson distribution
    k = min_val : max_val;
    poisson_probs = poisspdf(k, lambda_means(i));
    hPoisson = plot(k, poisson_probs, 'r-o', 'LineWidth', 1.5, 'MarkerSize', 4);

    % Formatting the subplot
    xlabel('Number of Counts per 1/10s Interval');
    ylabel('Probability');
    title(sprintf('Run %d: lambda = %.2f', i, lambda_means(i)));
    hold off;

    % Store plot handles for the legend from the first subplot
    if i == 1
        legendHandles = [hBar, hPoisson];
    end
    hold off;
end


lgd = legend(legendHandles, legendLabels, 'Orientation', 'horizontal');
lgd.Layout.Tile = 'south';
%saveas(gcf, 'fig6.png')