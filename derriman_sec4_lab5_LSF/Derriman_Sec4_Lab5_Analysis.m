%%
% part A-D is setup and collection only
%-----------------------------------------------
% PART E_1: import data for first run bg radiation
%-----------------------------------------------

% Import and extract data as table from text file
tbl = readtable('sec4_lab5_partB.txt');

% Extract 'Radiation' column data and assign it to an array
D_b1arr = tbl.Radiation; 

% Mean of decay events per sample
D_b1 =  mean(D_b1arr);

% Standard deviation of mean of N
Sigma_N =  std(D_b1arr) / sqrt(length(D_b1arr));

% Print results for best estimate and SDOM background radiation
fprintf("Distribution BG radiation before Ba-137 Decay:\n")
fprintf("Best estimate D_b1 = %10.2f ± %10.2f counts/s\n", D_b1, Sigma_N)

%%

%-----------------------------------------------
% PART E_2: import data for second run bg radiation
%-----------------------------------------------

% Import and extract data as table from text file
tbl = readtable('sec4_lab5_partD.txt');

% Extract 'Radiation' column data and assign it to an array
D_b2arr = tbl.Radiation; 

% Mean of decay events per sample
D_b2 =  mean(D_b2arr);

% Standard deviation of mean of N
Sigma_Db =  std(D_b2arr) / sqrt(length(D_b2arr));

% Print results for best estimate and SDOM background radiation
fprintf("Distribution BG radiation after Ba-137 Decay:\n")
fprintf("Best estimate D_b2 = %10.2f ± %10.2f counts/s\n", D_b2, Sigma_Db)

%%

% PART E_3: Calculate D = D* - D_b using D_b2 as D_b

% Import and extract data from step C
tbl = readtable('sec4_lab5_partC.txt');
T_arr = tbl.Time;        % time
Dstar = tbl.Radiation;   % counts

% Use D_b2 as D_b
D_b = D_b2;

% Calculate true decay rates by subtracting background radiation
D = Dstar - D_b;

% Calculate the natural logarithm of D_i
y = log(D);

% Number of data points
n = length(D);

% Calculate uncertainties in Dstar_i (Poisson)
sigma_Dstar = sqrt(Dstar);

% Calculate uncertainty in D_b (stand. err. mean)
sigma_Db = std(D_b2arr);

% Calculate uncertainties in D_i using error propagation
sigma_D = sqrt(sigma_Dstar.^2 + sigma_Db.^2);

% Calculate uncertainties in y_i = ln(D_i) using error propagation
sigma_Y = sigma_D ./ D;


%%
% PART F: Plot D vs t and lnD vs t
% --------------------------------

% Perform least squares fit on ln(D) vs t
wi = 1 ./( sigma_Y .^2);

Delta = sum(wi).*sum(wi.*(T_arr .^2))-(sum(wi.*T_arr).^2);

A = ((sum(wi.*(T_arr.^2)).*(sum(wi.*y))-(sum(wi.*T_arr)) ...
    .*(sum(wi .* T_arr .* y))))./ Delta;

B = ((sum(wi)).*(sum(wi.*T_arr.*y))...
    - (sum(wi.*T_arr)).*(sum(wi.*y)))./ Delta;

% Plot D vs t with error bars and exponential fit
figure(3);
hold on;
errorbar(T_arr, D, sigma_D, 'o'); % plot data with error bars

% Compute the exponential of the LSF to fit D vs t
LSF_D = exp(A + B.*T_arr); % transform LSF back to D scale
plot(T_arr, LSF_D, 'b-'); % plot the exponential fit

xlabel('Time t (s)');
ylabel('Decay Rate D (counts/s)');
title('Figure 3: Decay Rate D vs Time t with Exponential Fit');
legend('Data with error bars', 'Least Squares Fit', 'Location', 'Best');
grid on;
hold off;

% Plot ln(D) vs t with error bars and linear fit
figure(4);
hold on;
errorbar(T_arr,y, sigma_Y, 'ro');
LSF = A + B.*T_arr; % LSF for ln D vs t
plot(T_arr, LSF, 'b-'); % plot linear fit

xlabel('Time t (s)')
ylabel('ln(D)');
title('Figure 4: ln(D) vs Time t with Linear Fit');
legend('Data with error bars', 'Least Squares Fit', 'Location', 'Best');
grid on;
hold off;

%%
% Part G: Calculate sigma_A, and sigma_B, and chi^2

% Calculate sigma_A and sigma_B
sigma_A = sqrt(sum(wi .* T_arr.^2) / Delta);
sigma_B = sqrt(sum(wi) / Delta);

% Calculate chi^2 using the LSF variable
chi_squared = sum( (y - LSF).^2 ./ sigma_Y.^2);

%%
% Part H: Calculate tau_(1/2) and D_0 and errors

% Calculate D_0, initial decay rate (counts/s) and uncertainty
D0 = exp(A);
sigma_D0 = D0 * sigma_A;

% Calculate half-life and uncertainty
tau_half = log(2) / decay_constant;
sigma_tau_half = (log(2) / decay_constant^2) * sigma_decay_constant;

% Display results
fprintf('Parameter A = %.6f +/- %.6f\n', A, sigma_A);
fprintf('Parameter B = %.6f +/- %.6f (1/s)\n',B, sigma_B);
fprintf('D0 = %.2f +/- %.2f (counts/s)\n', D0, sigma_D0);
fprintf('tau_(1/2) = %.2f +/- %.2f (s)\n', tau_half, sigma_tau_half);
fprintf('Chi-squared = %.2f\n', chi_squared);


