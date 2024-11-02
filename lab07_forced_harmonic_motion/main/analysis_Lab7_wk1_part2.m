% Analysis of Forced Harmonic Motion Data
% This script processes multiple voltage files and generates required plots/calculations

% List of voltage files to process
voltages = [2.00, 3.18, 4.14, 4.25, 4.35, 4.45, 4.55, 4.65, 4.78, 4.85, ...
           4.95, 5.05, 5.16, 5.26, 5.35, 6.00, 9.50];

% Initialize arrays to store results
n_files = length(voltages);
amplitudes = zeros(n_files, 1);
phases = zeros(n_files, 1);
frequencies = zeros(n_files, 1);
v_max = zeros(n_files, 1);

% Process each voltage file
for i = 1:n_files
    % Construct filename
    filename = sprintf('clean_Lab7_%.2fV.txt', voltages(i));
    
    % Load data
    data = readtable(filename);
    time = data.Time;
    position = data.Position;
    angle = data.Angle2;  % Using Angle2 from data
    
    % Calculate period from time series
    [peaks, peak_locs] = findpeaks(position);
    periods = diff(time(peak_locs));
    avg_period = mean(periods);
    frequencies(i) = 2*pi/avg_period;  % Convert to angular frequency
    
    % Calculate amplitude
    amplitude = (max(position) - min(position))/2;
    amplitudes(i) = amplitude;
    
    % Calculate phase difference between position and angle
    % First find peaks in both signals
    [pos_peaks, pos_locs] = findpeaks(position);
    [ang_peaks, ang_locs] = findpeaks(angle);
    
    % Calculate phase difference
    phase_diff = 2*pi * (time(pos_locs(1)) - time(ang_locs(1))) / avg_period;
    phases(i) = phase_diff;
    
    % Calculate maximum velocity
    v_max(i) = amplitudes(i) * frequencies(i);
end

% Sort all arrays by frequency for plotting
[frequencies, sort_idx] = sort(frequencies);
amplitudes = amplitudes(sort_idx);
phases = phases(sort_idx);
v_max = v_max(sort_idx);

% Create plots
figure('Name', 'Amplitude vs. Frequency');
plot(frequencies, amplitudes, 'o-');
xlabel('Angular Frequency (rad/s)');
ylabel('Amplitude (m)');
title('Amplitude vs. Angular Frequency');
grid on;

figure('Name', 'Maximum Velocity vs. Frequency');
plot(frequencies, v_max, 'o-');
xlabel('Angular Frequency (rad/s)');
ylabel('Maximum Velocity (m/s)');
title('Maximum Velocity vs. Angular Frequency');
grid on;

figure('Name', 'Phase vs. Frequency');
plot(frequencies, phases, 'o-');
xlabel('Angular Frequency (rad/s)');
ylabel('Phase (rad)');
title('Phase vs. Angular Frequency');
grid on;

% Find resonant frequency (ω0) from peak of v_max
[max_v, max_idx] = max(v_max);
omega_0 = frequencies(max_idx);

% Find frequencies where v_max = 0.707 * peak_v_max
threshold = 0.707 * max_v;
left_idx = find(v_max(1:max_idx) <= threshold, 1, 'last');
right_idx = max_idx + find(v_max(max_idx:end) <= threshold, 1) - 1;

% Calculate 2Δω
delta_omega = frequencies(right_idx) - frequencies(left_idx);

% Calculate Q
Q = omega_0 / delta_omega;

% Calculate γ
gamma = omega_0 / (2*Q);

% Now we can generate theoretical curves using these parameters
omega_range = linspace(min(frequencies), max(frequencies), 1000);
F0_over_m = max_v * 2 * gamma;  % Estimate F0/m from peak velocity

% Calculate theoretical curves
v_max_theory = F0_over_m .* omega_range ./ ...
    sqrt((omega_0^2 - omega_range.^2).^2 + 4*gamma^2.*omega_range.^2);

phi_theory = atan2(2*gamma.*omega_range, omega_0^2 - omega_range.^2);
k = find(phi_theory > 0); 
phi_theory(k) = phi_theory(k) - pi;  % Correct phase range as per manual

% Add theoretical curves to plots
figure('Name', 'Maximum Velocity vs. Frequency with Theory');
plot(frequencies, v_max, 'o', omega_range, v_max_theory, '-');
xlabel('Angular Frequency (rad/s)');
ylabel('Maximum Velocity (m/s)');
title('Maximum Velocity vs. Angular Frequency');
legend('Experimental', 'Theoretical');
grid on;

figure('Name', 'Phase vs. Frequency with Theory');
plot(frequencies, phases, 'o', omega_range, phi_theory, '-');
xlabel('Angular Frequency (rad/s)');
ylabel('Phase (rad)');
title('Phase vs. Angular Frequency');
legend('Experimental', 'Theoretical');
grid on;

% Display results
fprintf('Results:\n');
fprintf('Resonant frequency (ω0): %.2f rad/s\n', omega_0);
fprintf('Quality factor (Q): %.2f\n', Q);
fprintf('Damping constant (γ): %.2f rad/s\n', gamma);
fprintf('2Δω: %.2f rad/s\n', delta_omega);