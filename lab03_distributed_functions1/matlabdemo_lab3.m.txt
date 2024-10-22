%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lab 3: Propagation of Errors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sang-Hyuk Lee
% Date 09/23/2024

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Important !!!
% This script is provided to help students with  using key Matlab functions relevant to Lab 3.
% Students should properly adapt or modify it for their own analysis and plotting of Lab 3 data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------------------------
% Sampling of a Poisson distribution
%-------------------------------------
mu = 10;
N_sample = 10000;
nu_array = poissrnd(mu, N_sample, 1);

%-------------------------------------
% Estimate mu from the sample data 
%-------------------------------------
mu_sample = mean(nu_array);

%-------------------------------------
% Plot histogram
%-------------------------------------
x = min(nu_array):max(nu_array);

% Get counts and centers
[counts, centers] = hist(nu_array, x);

% Plot probability by normalizing counts by N_sample
color_hist = '#0072BD';
bar(centers, counts/N_sample, 'EdgeColor', 'w', 'FaceColor', color_hist);

hold on

%-------------------------------------
% Plot Poisson distribution  
%-------------------------------------
y_poiss = poisspdf(x, mu);

color_poiss = '#7E2F8E';
plot(x, y_poiss, '--o', 'Color', color_poiss, 'MarkerFaceColor', color_poiss, 'MarkerSize', 8)

%-------------------------------------
% Plot Gaussian distribution  
%-------------------------------------
y_norm = normpdf(x, mu, sqrt(mu));

color_norm = 'r';
plot(x, y_norm, '-', 'Color', color_norm)


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
title(sprintf('\\mu = %g,  N_{sample} = %d;      \\mu_{sample} = %g', mu, N, mu_sample), 'FontSize', 16);

% Label x and y axis
xlabel('\nu', 'FontSize', 18);
ylabel('f(\nu)', 'FontSize', 18);

hold off

%-------------------------------------
% Saving Figures in Mat 
%-------------------------------------
% 1. First save the figure in Matlab Figure format.
%    This way, you can open the figure later and edit it if necessary. 
%
%    Go to the Figure window > Files > Save
%
% 2. Use 'export_fig' to export the figure to a nice publication quality 'PNG' image file 
%    to import it into MS Word document later. export_fig is not a builtin function but should
%    be donwloaded from https://github.com/altmany/export_fig. You can read the github page
%    to learn how to use it. 

