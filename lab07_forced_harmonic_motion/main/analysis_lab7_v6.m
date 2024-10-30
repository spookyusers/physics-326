% Kym Derriman
% Partner: Evan Howell
% Date: 10/28/2024
% Lab 07: Forced Harmonic Motion

%% Part 1 (A): Determine Natural Frequency

% Clear workspace
clc; clear; close all;

% Read the three cases
data1 = readtable("clean_Lab7_EvA1.txt");
data2 = readtable("clean_Lab7_EvA2.txt");
data3 = readtable("clean_Lab7_EvA3.txt");

% Analyze each case
[period1, period_err1, phase1] = analyzeOscillations(data1.Time, ...
    data1.Position - mean(data1.Position), ...
    data1.Angle2 - mean(data1.Angle2));  % Note: Angle2 instead of Angle
freq1 = 1/period1;

[period2, period_err2, phase2] = analyzeOscillations(data2.Time, ...
    data2.Position - mean(data2.Position), ...
    data2.Angle2 - mean(data2.Angle2));
freq2 = 1/period2;

[period3, period_err3, phase3] = analyzeOscillations(data3.Time, ...
    data3.Position - mean(data3.Position), ...
    data3.Angle2 - mean(data3.Angle2));
freq3 = 1/period3;

% Display results in a table format
results = table([period1; period2; period3], [period_err1; period_err2; period_err3], ...
    [freq1; freq2; freq3], 'VariableNames', {'Period', 'Error', 'Frequency'}, ...
    'RowNames', {'No Disk', 'Equiv Mass', 'With Disk'});
disp(results)

% Plot 1: Period comparison
figure
errorbar(1:3, [period1, period2, period3], [period_err1, period_err2, period_err3], 'bo', 'MarkerFaceColor', 'b')
xticks(1:3)
xticklabels({'No Disk', 'Equiv Mass', 'With Disk'})
title('Period Comparison')
ylabel('Period (s)')
grid on

% Plot 2: Position data
figure
plot(data1.Time, data1.Position - mean(data1.Position), 'b-', ...
     data2.Time, data2.Position - mean(data2.Position), 'r-', ...
     data3.Time, data3.Position - mean(data3.Position), 'g-')
title('Centered Position Data')
xlabel('Time (s)')
ylabel('Position (m)')
legend('No Disk', 'Equiv Mass', 'With Disk')
grid on

% Plot 3: Angle data
figure
plot(data1.Time, data1.Angle2, 'b-', ...
     data2.Time, data2.Angle2, 'r-', ...
     data3.Time, data3.Angle2, 'g-')
title('Angle Data')
xlabel('Time (s)')
ylabel('Angle (rad)')
legend('No Disk', 'Equiv Mass', 'With Disk')
grid on

%% Part 2
% Clear everything
clc; clear; close all;

% Define voltages (all with 2 decimal places)
Voltages = [2.00, 3.18, 4.14, 4.25, 4.35, 4.45, 4.55, 4.65, 4.78, 4.85, ...
    4.95, 5.05, 5.16, 5.26, 5.35, 6.00, 9.50];

% Initialize arrays
Amplitude = zeros(size(Voltages));
Phase = zeros(size(Voltages));
Frequencies = zeros(size(Voltages));
Vmax = zeros(size(Voltages));

% Loop through voltages
for i = 1:length(Voltages)
    V = Voltages(i);
    % Read data - note the "clean_" prefix
    filename = sprintf("clean_Lab7_%.2fV.txt", V);
    data = readtable(filename);
    
    time = data.Time;
    position = data.Position;
    angle = data.Angle2;
    
    position_centered = position - mean(position);
    angle_centered = angle - mean(angle);
    [period, ~, phase] = analyzeOscillations(time, position_centered, angle_centered);
    freq = 1/period;
    amp = (max(position_centered) - min(position_centered))/2;
    Amplitude(i) = amp;
    Phase(i) = phase;
    Frequencies(i) = freq;
    Vmax(i) = 2*pi*freq*amp;
end


figure
plot(Frequencies, Amplitude, 'o')
title('Amplitude vs Frequency')

figure
plot(Frequencies, Phase, 'o')
title('Phase vs Frequency')

figure
plot(Frequencies, Vmax, 'o')
title('Vmax vs Frequency')

% Display basic results table
results = table(Voltages', Frequencies', Amplitude', Phase', Vmax', ...
    'VariableNames', {'Voltage', 'Frequency', 'Amplitude', 'Phase', 'Vmax'});
disp(results)

%% Messing / Testing code

% Get data (wtf are my column names!!?)
filename = ("Lab7_2.00V.txt");
data = readtable(filename);
disp(['Column names in file ',filename, ':'])
disp(data.Properties.VariableNames)

% filename = sprintf("Lab7_%.2fV.txt", V);
%     data = readtable(filename);
% 
%     % Get data (wtf are my column names!!?)
%     disp(['Column names in file ', filename, ':'])
%     disp(data.Properties.VariableNames)