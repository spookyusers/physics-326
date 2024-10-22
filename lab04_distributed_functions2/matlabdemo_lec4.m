%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lab 4: Distribution of the Mean 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sang-Hyuk Lee
% Date 09/30/2024

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Important !!!
% This script is provided to help students with  using key Matlab functions relevant to Lab 3.
% Students should properly adapt or modify it for their own analysis and plotting of Lab 3 data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%-------------------------------------
% Data 
%-------------------------------------

% Time interval (i.e., exposure of detector) for a single acquision of radiation counts (in second)
delta_t = 0.5;

% Array of different acquisition times (in second)
T_data_arr = [1, 2, 4, 8, 15, 30, 60, 120, 300, 600];

% Number of data for each acquisition time
num_data_arr = T_data_arr /delta_t;	

% Mean radiation counts for each acquisition time
Nbar_arr = [35, 32.5, 32.25, 32.25, 31.867, 30.983, 32.108, 32.35, 31.545, 31.715];

% Standarad deviation of radiation counts (N) for each acquisition time
Sigma_N_arr = [5.9161, 5.7009, 5.6789, 5.6789, 5.6451, 5.5663, 5.6664, 5.6877, 5.6165, 5.6316]; 

% Standard deviation of mean radiation counts (Nbar) for each acqusition time  
Sigma_Nbar_arr = Sigma_N_arr ./ sqrt(num_data_arr);

%-------------------------------------
% Plotting
%-------------------------------------
% 1. Plot Nbar vs Sigma_Nbar

% x-axis data 
X_arr = num_data_arr;

% y-axis data
Y_arr = Nbar_arr; 

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
Nbar_best =  Nbar_arr(end); 

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
formatfig(gcf, 'line', 'stretch',[0.9, 0.9])

% Remove plot box
box('off')

% Figure title
title('$\bar{N} (n) \pm \sigma_{\bar{N}} (= \sigma/\sqrt{n})$', 'FontSize', 16, 'Interpreter', 'latex');

% Label x and y axis
xlabel('Number of data points (n)', 'FontSize', 16);
ylabel('Mean Radiation Count', 'FontSize', 16);


% Adjust axis width to show the full title
pos_old = get(gca, 'Position');
pos_new = [pos_old(1:3), 0.72];
set(gca, 'Position', pos_new);


