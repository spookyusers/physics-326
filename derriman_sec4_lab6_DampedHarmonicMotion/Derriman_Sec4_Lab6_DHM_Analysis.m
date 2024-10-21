% Kym Derriman (Partner: Evan Howell)
% Lab 6: Damped Harmonic Motion
% 10/17/2024

clc;clear;close all;

% Preallocation and setup
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

% Plot: Position vs. Mass (pos inverted for displacement)
weights = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5];
displArr1 = max(pos_means) - pos_means; 

figure;     grid on;    box on;
errorbar(weights, displArr1, pos_stdMean, 'ro', 'MarkerSize', 5, 'DisplayName', 'Displacement vs Mass');
title('Displacement vs Mass', 'FontSize', 14);
xlabel('Mass (kg)', 'FontSize', 11);
ylabel('Displacement (m)', 'FontSize', 11);
legend('Location', 'northwest');
set(gca, 'FontSize', 12);

% LSF: force vs position according to Hooke's Law (F = k * x)
g = 9.81;                       % gravity acceleration
force = weights * g;            % force = mass * gravity
w = 1 ./ (pos_stdMean .^ 2);    % 1 / (standard error mean)^2

[A, B, sigA, sigB] = calculate_linLSF(force, displArr1, w);
k = abs(1 / B);                 % AbsValue avoids complex numbers
sigk = sigB / (B^2);            % Error propagates from B

% Plot Linear Fit (Force vs Displacement) with error bars
figure;
grid on;    box on;     hold on;
errorbar(force, displArr1, pos_stdMean, 'ro', 'DisplayName', 'Force vs Displacement');
x_fit = linspace(min(force), max(force), 100);
y_fit = B * x_fit + A;

plot(x_fit, y_fit,'k--', 'LineWidth', 1, 'DisplayName', 'Linear Fit');
xlabel('Force (N)', 'FontSize', 11);
ylabel('Displacement (m)', 'FontSize', 11);
title('Force vs Displacement (Linear Fit for Spring Constant)');
legend('Location', 'northwest');
xlim([min(force), max(force)]);
hold off;

% Print the Results
fprintf('Parameters and Uncertainties y = Bx + A:\n');
fprintf('----------------------------------------------------------\n');
fprintf('Intercept (A) = %.4f ± %.4f m\n', A, sigA);
fprintf('Slope (B) = %.4f ± %.4f 1/N\n', B, sigB);
fprintf('Spring constant (k) = %.2f ± %.2f N/m\n', k, sigk);
fprintf('----------------------------------------------------------\n');

% --------------------------------------------
% Spring Force vs Displacement Analysis (500g)
% --------------------------------------------

% Data from oscillating spring with 500g weight attached.
tbl = readtable("L6_500g_Oscillation.txt");
t = tbl.Time;
posArr = tbl.Position;
velArr = tbl.Velocity;
accelArr = tbl.Acceleration;
% Invert positions to get displacement
displArr2 = posArr - mean(posArr); 

% Plot Displacement, Velocity, Acceleration Data
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

% Find Zero Crossings for Position, Velocity, Acceleration
[pos_crossTimes, pos_crossIndex] = zeroCross(displArr2, t);
[vel_crossTimes, vel_crossIndex] = zeroCross(velArr, t);
[accel_crossTimes, accel_crossIndex] = zeroCross(accelArr, t);

% Period and Relative Phase
weights = 1/30;
[T, sigmaT,~,~] = periodPhase(pos_crossTimes, weights, 'Position');
periodPhase(vel_crossTimes, weights, 'Velocity');
periodPhase(accel_crossTimes, weights, 'Acceleration');

% Compare Measured Period with Theoretical Value
% -----------------------------------------------------------------

% Mass of weight holder, weight, and spring (1/3 * spring mass), g to kg
mass_holder = 99.1 / 1000;
mass_weight = 500 / 1000;
mass_spring_eff = 29.2 / 1000;
total_mass = mass_holder + mass_spring_eff + mass_weight;

% Calculate theoretical value of T with T = 2 * pi * sqrt(m / k)
T_theoretical = 2 * pi * sqrt(total_mass / k);
sigma_T_theoretical = T_theoretical * (sigk / (2 * k));

% Print Results for Measured vs Theoretical Period
fprintf('----------------------------------------------------------\n');
fprintf('Period of Oscillation (T) = %.3f ± %.4f seconds\n', T, sigmaT);
fprintf('Theoretical Period (T) = %.3f ± %.4f seconds\n', T_theoretical, sigma_T_theoretical);
fprintf('----------------------------------------------------------\n');

% Compare Measured Period with Theoretical
if abs(T - T_theoretical) <= (sigmaT + sigma_T_theoretical)
    fprintf('Measured period is within the uncertainty bounds of theor. value.\n');
else
    fprintf('Measured period deviates significantly from theor. value.\n');
end

% Plot Velocity as a Function of Position
figure;
grid on; box on;
plot(posArr, velArr, 'b');
title('Velocity vs Position');
xlabel('Position (m)');
ylabel('Velocity (m/s)');
legend('Velocity vs Position');

