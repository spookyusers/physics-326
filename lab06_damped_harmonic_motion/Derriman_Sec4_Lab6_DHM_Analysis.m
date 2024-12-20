%% Lab 6: Damped Harmonic Motion
% Kym Derriman (Partner: Evan Howell)
% 10/17/2024
clc;clear;close all;
%% 100g weights (Steps 1-3)
% Preallocation, Data Import, and Setup
num = 6;
pos_means = zeros(1, num);
pos_std = zeros(1, num);
pos_stdMean = zeros(1, num);
filename_temp = "S4L6_%d.txt";

for i = 1:num
    % Read data from corresponding file
    data = readtable(sprintf(filename_temp, i));
    current_positions = data.Position;
    N = length(current_positions);

    % Store original mean and calculate std deviation and std error mean
    pos_means(i) = mean(current_positions);
    pos_std(i) = std(current_positions);
    pos_stdMean(i) = pos_std(i) / sqrt(N);
end

%% Plot Displacement vs Mass (Step 4, Figure 1)
% Calculate displacement (inverted positions)
displArr1 = max(pos_means) - pos_means; 

% Masses used in kg
weights = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5];

% Plot: Displacement vs. Mass
figure; grid on; box on;
errorbar(weights, displArr1, pos_stdMean, 'ro', 'MarkerSize', 5, 'DisplayName', 'Data with Error Bars');
%title('Displacement vs Mass', 'FontSize', 14);
xlabel('Mass (kg)', 'FontSize', 11);
ylabel('Displacement (m)', 'FontSize', 11);
legend('Location', 'northwest');
set(gca, 'FontSize', 12);

% Perform LSFit (Steps 5,6,7,8)
w = 1 ./ (pos_stdMean .^ 2);    % Weights for LSF
[A, B, sigA, sigB] = calculate_linLSF(weights, displArr1, w);

% Calculate Spring Constant from Slope
g = 9.81;
k = g / B;
sigk = sigB * g / (B^2);    % Propagate uncertainty

x_fit = linspace(min(weights), max(weights), 100);
y_fit = A + B * x_fit;

hold on;
plot(x_fit, y_fit,'k--', 'LineWidth', 1, 'DisplayName', 'Linear Fit');
hold off;
legend('Data with Error Bars', 'Linear Fit', 'Location', 'northwest');

% Print the Results (Step 8 Results)
fprintf('Parameters and Uncertainties y = A + Bx:\n');
fprintf('----------------------------------------------------------\n');
fprintf('Intercept (A) = %.9f ± %.6f m\n', A, sigA);
fprintf('Slope (B) = %.9f ± %.6f m/kg\n', B, sigB);
fprintf('Spring constant (k) = %.4f ± %.4f N/m\n', k, sigk);
fprintf('----------------------------------------------------------\n');
%% 500g Weights and Plot X, V, A (Step 8,9, Fig 3)
tbl = readtable("L6_500g_Oscillation.txt");
t = tbl.Time;
posArr = tbl.Position;
velArr = tbl.Velocity;
accelArr = tbl.Acceleration;
% Invert positions to get displacement
displArr2 = posArr - mean(posArr); 

figure;
subplot(3,1,1);
plot(t, displArr2);
title('Position vs Time*');
xlabel('Time (s)'); ylabel('Position (m)');

subplot(3,1,2);
plot(t, velArr);
title('Velocity vs Time');
xlabel('Time (s)'); ylabel('Velocity (m/s)');

subplot(3,1,3);
plot(t, accelArr);
title('Acceleration vs Time');
xlabel('Time (s)'); ylabel('Acceleration (m/s^2)');

% Add annotation to indicate the asterisk explanation
annotation('textbox', [0.1, 0.01, 0.8, 0.05],'String', ...
    '*Values shifted by mean to oscillate about zero.','EdgeColor', ...
    'none','HorizontalAlignment', 'center', 'FontSize', 10);
%% Find Zero Crossings, Period and Relative Phase (Step 10-14)
% Find zero crossings for position, velocity, and acceleration
[pos_crossTimes, pos_crossIndex] = zeroCross(displArr2, t);
[vel_crossTimes, vel_crossIndex] = zeroCross(velArr, t);
[accel_crossTimes, accel_crossIndex] = zeroCross(accelArr, t);

% Define weight for period-phase calculation
weights = 1/30;

% Calculate period, uncertainty, phase difference, and its uncertainty for each parameter
[T, sigmaT, dphi_pos, sigmadphi_pos] = periodPhase(pos_crossTimes, weights, 'Position');
[T_v, sigmaT_v, dphi_vel, sigmadphi_vel] = periodPhase(vel_crossTimes, weights, 'Velocity');
[T_a, sigmaT_a, dphi_accel, sigmadphi_accel] = periodPhase(accel_crossTimes, weights, 'Acceleration');

% Calculate phase differences (without uncertainties) between derived quantities
phasediff_vel_pos = abs(dphi_vel - dphi_pos);
phasediff_accel_pos = abs(dphi_accel - dphi_pos);

% Define masses of system components (in kg)
mass_holder = 99.1 / 1000;
mass_weight = 500 / 1000;
mass_spring_eff = 29.2 * 0.369 / 1000;
total_mass = mass_holder + mass_spring_eff + mass_weight;

% Calculate theoretical period with T = 2 * pi * sqrt(m / k)
T_theoretical = 2 * pi * sqrt(total_mass / k);
sigma_T_theoretical = T_theoretical * (sigk / (2 * k));

% Display results for period and phase differences, omitting uncertainties for derived phase differences
fprintf('----------------------------------------------------------\n');
fprintf('Period of Oscillation (T) = %.4f ± %.4f seconds\n', T, sigmaT);
fprintf('Phase Difference (Velocity - Position) = %.4f\n', phasediff_vel_pos);
fprintf('Phase Difference (Acceleration - Position) = %.4f\n', phasediff_accel_pos);
fprintf('Theoretical Period (T) = %.4f ± %.4f seconds\n', T_theoretical, sigma_T_theoretical);

% Compare measured period with theoretical period
if abs(T - T_theoretical) <= (sigmaT + sigma_T_theoretical)
    fprintf('Measured period is within the uncertainty bounds of the theoretical value.\n');
else
    fprintf('Measured period deviates significantly from the theoretical value.\n');
end
fprintf('----------------------------------------------------------\n');

%% Part H: Phase Space Plot Velocity vs Position
figure;
grid on; box on;
plot(posArr, velArr, 'b');
title('Velocity vs Position');
xlabel('Position (m)');
ylabel('Velocity (m/s)');
legend('Velocity vs Position');

%% Part I: Paper Plate Section

tbl = readtable("L6_paperPlate_Oscillation.txt");
t = tbl.Time;
posArr = tbl.Position;
velArr = tbl.Velocity;
accelArr = tbl.Acceleration;

% Invert positions to get displacement
displArr2 = posArr - mean(posArr); 

% Calculating Amplitude Decay (Max Min Peaks)
% Find zero crossings of velocity with directions
[vel_crossTimes, vel_crossIndices, crossingDirections] = zeroCross2(velArr, t);

% Get positions at zero crossings of velocity
peak_positions = displArr2(vel_crossIndices);
peak_times = t(vel_crossIndices);

% Separate maxima and minima based on crossing directions
max_indices = vel_crossIndices(crossingDirections == -1);
min_indices = vel_crossIndices(crossingDirections == 1);

max_positions = displArr2(max_indices);
max_times = t(max_indices);

min_positions = displArr2(min_indices);
min_times = t(min_indices);

% Combine maxima and minima
all_peak_times = [max_times; min_times];
all_peak_positions = [max_positions; min_positions];

% Linear Regression and Damping Coefficient

% Prepare Peak Data for Log Plotting
[sorted_times, sort_idx] = sort(all_peak_times);
sorted_amplitudes = abs(all_peak_positions(sort_idx));
ln_amplitudes = log(sorted_amplitudes);

% Plot natural log of amplitude vs time
figure;
grid on; box on;
plot(sorted_times, ln_amplitudes, 'b');
title('Natural log of Amplitude vs Time');
xlabel('time (s)');
ylabel('amplitude (m)');
legend('log(amplitude)');

% Perform Linear Regression
w = ones(size(sorted_times));
[A, B, sigmaA, sigmaB] = calculate_linLSF(sorted_times, ln_amplitudes, w);

% Extract Parameters
gamma = -B;
sigma_gamma = sigmaB;

A0 = exp(A);
sigma_A0 = A0 * sigmaA;

R = 2 * total_mass * gamma;
sigma_R = 2 * total_mass * sigma_gamma;

fprintf('Damping coefficient (gamma): %.4f ± %.4f s^-1\n', gamma, sigma_gamma);
fprintf('Damping force coefficient (R): %.4f ± %.4f kg/s\n', R, sigma_R);
fprintf('Initial amplitude (A0): %.4f ± %.4f m\n', A0, sigma_A0);

% Plot ln(Amplitude) vs. Time with Linear Fit
figure;
scatter(sorted_times, ln_amplitudes, 'ko', 'DisplayName', 'Data');
hold on;
t_fit = linspace(min(sorted_times), max(sorted_times), 100);
ln_amplitude_fit = A + B * t_fit;
plot(t_fit, ln_amplitude_fit, 'r-', 'LineWidth', 2, 'DisplayName', 'Linear Fit');
xlabel('Time (s)');
ylabel('LSF Natural Log Amplitude');
title('Fitted Log of Amplitude vs. Time');
legend('show');
grid on;
hold off;



