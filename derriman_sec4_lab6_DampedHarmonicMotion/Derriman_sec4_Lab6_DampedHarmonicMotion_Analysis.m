
% Kym Derriman (Partner: Ethan Howell)
% Lab 6: Damped Harmonic Motion
% 10/17/2024

%%
% -------------------------------------
% Spring Force vs Displacement Analysis
% -------------------------------------

% Import data
% data1 = readtable("S4L6C1.txt");  % LoggerPro
% data2 = readtable("S4L6C2.txt"); % Calculated


% Arrays: Force (LoggerPro, Calculated)
%force_LP = data1.Force;
%force_C = data2.Force; 

% Arrays: Displacement (LoggerPro, Calculated)
%displacement_LP = data1.Displacement;
%displacement_C = data2.Displacement;

% mass of weights (stamped)
% m = [] % read from weights

% -------------------------------
% Sample Data
% -------------------------------

% Mass of weights (first is used for "stretched" position)
mass = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6]; % in kg
g = 9.80; % acceleration due to gravity in m/s^2

% Calculated Force based on mass (F = m * g)
force_C = g .* mass; % in Newtons (N)

% Force measured using LoggerPro (simulated with slight experimental variation)
force_LP = force_C .* (1 + 0.02*randn(1,6)); % adding ~2% random noise

% Displacement measured using LoggerPro (simulated data in meters)
disp_LP = [0.02, 0.04, 0.06, 0.08, 0.10, 0.12] + 0.001*randn(1,6); % meters

% Displacement measured using meterstick (more precise measurements in meters)
disp_mS = [0.0195, 0.0398, 0.0602, 0.0801, 0.1003, 0.1200] + 0.0005*randn(1,6); % meters

% -------------------------------
% Uncertainties
% -------------------------------

% Force uncertainty
fT_uncertainty = 0.10 * force_LP; % 10% uncertainty from force transducer

% Mass uncertainty
mass_uncertainty = 0.001; % kg (check manufacturer for precise value)

% Displacement uncertainty
mS_uncertainty = 0.005; % meters (1 cm markings on meterstick)
uPs_uncertainty = 0.005; % meters (assuming ultrasonic position sensor uncertainty

% Total Force Uncertainty (combining transducer and mass uncertainty)
% delta_F = F * sqrt( (dfT/F)^2 + (dm/m)^2 )
force_total_uncertainty = sqrt(fT_uncertainty.^2 + (g * mass_uncertainty).^2); % in N

% Total Displacement Uncertainty
disp_total_uncertainty = sqrt(mS_uncertainty^2 + uPs_uncertainty^2); % in meters

% -------------------------------
% Calculate Mean Values
% -------------------------------

% Mean Force from LoggerPro
mean_force_LP = mean(force_LP);

% Mean Calculated Force
mean_force_C = mean(force_C);

% Mean Displacement from LoggerPro
mean_disp_LP = mean(disp_LP);

% Mean Displacement from Meterstick
mean_disp_mS = mean(disp_mS);

% -------------------------------
% Calculate Slope (Spring Constant k)
% -------------------------------

% Using linear regression (force vs. displacement)
% F = -k * x

% Prepare data for regression
X = disp_mS'; % independent variable (displacement) in meters
Y = force_LP'; % dependent variable (force) in Newtons

% Number of data points
N = length(X);

% Calculate means of X and Y
mean_X = mean(X);
mean_Y = mean(Y);

% Calculate the covariance of X and Y and the variance of X
Cov_XY = sum( (X - mean_X) .* (Y - mean_Y) );
Var_X = sum( (X - mean_X).^2 );

% Calculate slope (k) and intercept (b) using least squares formulas
k = Cov_XY / Var_X; % Spring constant in N/m
b = mean_Y - k * mean_X; % y-intercept in N

% Display the calculated slope and intercept
fprintf('Calculated Spring Constant (k): %.2f N/m\n', k);
fprintf('Calculated Intercept (b): %.2f N\n', b);

% -------------------------------
% Calculate Uncertainty in Slope (sigma_k)
% -------------------------------

% Compute fitted Y values based on the regression line
fitted_Y = k * X + b;

% Calculate residuals (differences between observed and fitted Y values)
residuals = Y - fitted_Y;

% Calculate the sum of squared residuals
SS_res = sum(residuals.^2);

% Calculate the variance of residuals
s_squared = SS_res / (N - 2); % Degrees of freedom = N - 2

% Calculate the standard error of the slope (k)
sigma_k = sqrt( s_squared / Var_X );

% Display the uncertainty in slope
fprintf('Uncertainty in Spring Constant (sigma_k): ± %.2f N/m\n', sigma_k);


% -------------------------------
% Plot: Force vs. Displacement
% -------------------------------

figure; hold on; grid on; box on;

% Plot LoggerPro Data with error bars
errorbar(disp_LP, force_LP, fT_uncertainty, 'ro-', 'LineWidth', 2, 'MarkerSize',8, 'DisplayName','LoggerPro Measured');

% Plot Calculated Force (F = m * g) with error bars
errorbar(disp_mS, force_C, force_total_uncertainty, 'bs-', 'LineWidth', 2, 'MarkerSize',8, 'DisplayName','Calculated Force');

% Plot Linear Fit
x_fit = linspace(min(disp_mS)*0.95, max(disp_mS)*1.05, 100);
y_fit = k * x_fit + b;
plot(x_fit, y_fit, 'k--', 'LineWidth', 2, 'DisplayName',sprintf('Fit: F = %.2f x + %.2f', k, b));

% Title and Labels with Uncertainties
title('Force vs. Displacement: LoggerPro vs. Calculated Data', 'FontSize', 14);
xlabel('Displacement (m)', 'FontSize', 12);
ylabel('Force (N)', 'FontSize', 12);
legend('Location','northwest');
set(gca, 'FontSize', 12);

% -------------------------------
% Display the Results
% -------------------------------

fprintf('Calculated Spring Constant (k): %.2f N/m\n', k);
fprintf('Uncertainty in k: ± %.2f N/m\n', sigma_k);
fprintf('Intercept (b): %.2f N\n', b);
fprintf('Uncertainty in Intercept (b): ± %.2f N\n', SE * sqrt( sum(X.^2) / (length(X)*sum((X - mean(X)).^2) )) ); % approximate

% Optional: Display Mean Values
fprintf('\nMean Force (LoggerPro): %.2f N\n', mean_force_LP);
fprintf('Mean Calculated Force: %.2f N\n', mean_force_C);
fprintf('Mean Displacement (LoggerPro): %.3f m\n', mean_disp_LP);
fprintf('Mean Displacement (Meterstick): %.3f m\n', mean_disp_mS);


%%

% ----------------------------------
% Part E: Plot d, v, a, t
% ----------------------------------

% Import data
data= readtable("S4L6D.txt");

% Arrays: 
d = data.Displacement; v = data.Velocity;
a = data.Acceleration; t = data.Time;

% Plot: Position, Velocity, Accel. vs Time 
% ----------------------------------------

% Plot position vs time
figure; plot(t, d,'o-' ,'LineWidth', 2); title('Position vs Time');
xlabel('Time (s)'); ylabel('Position (m)'); legend('show'); grid on;

% Plot velocity vs time
figure; plot(t, v,'k-' ,'LineWidth', 2); title('Velocity vs Time');
xlabel('Time (s)'); ylabel('Velocity (m/s)'); legend('show'); grid on;

% Plot acceleration vs time
figure; plot(t, a,'o-' ,'LineWidth', 2); title('Acceleration vs Time');
xlabel('Time (s)'); ylabel('Acceleration (m/s^2)');
legend('show'); grid on;

%%
% Part F: Find Period of Oscillation and Estimate Error
% ----------------------------------------------------

% Find peaks in the displacement data
[peaks, locs] = findpeaks(d, t); % locs gives the times of the peaks

% Calculate individual periods
periods = diff(locs);  % Time differences between consecutive peaks

% Calculate the average period
average_period = mean(periods); 

% Estimate the error (standard deviation of the periods)
std_period = std(periods);   % Standard deviation of the periods

% Estimate the uncertainty (standard error of the mean)
N = length(periods);         % Number of periods measured
error_T = std_period / sqrt(N);  % Standard error of the mean

% Compare results against theoretical value for period T
% ------------------------------------------------------

% Known values
mass_weight = 0.5;  % Mass stamped on the weight/s (in kg)
mass_holder = 0.1;  % Mass of the weight holder (in kg)
k = 10;  % Spring constant (N/m)

% Total mass
m_total = mass_weight + mass_holder;  % Total mass in kg

% Theoretical period
T_theory = sqrt((2 * pi * m_total) / k);

% Calculate percent error
percent_error = abs((average_period - T_theory) / T_theory) * 100;

% Display results
disp(['Theoretical period: ', num2str(T_theory), ' seconds.']);
disp(['Experimental period: ', num2str(average_period), ' seconds.']);
disp(['Error in experimental period: ±', num2str(error_T), ' seconds.']);
disp(['Percent error: ', num2str(percent_error), '%.']);
















%-------------------------------------------------------------

