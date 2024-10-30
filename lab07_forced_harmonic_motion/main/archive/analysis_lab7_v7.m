% Clear workspace
clc; clear; close all;

% Read multiple trials for each case
% Case 1: No disc
trials1 = {'clean_Lab7_EvA1.txt', 'clean_Lab7_EvA2.txt', 'clean_Lab7_EvA3.txt'}; 
periods1 = zeros(length(trials1), 1);
for i = 1:length(trials1)
    data = readtable(trials1{i});
    [period, ~, ~] = analyzeOscillations(data.Time, ...
        data.Position - mean(data.Position), ...
        data.Angle2 - mean(data.Angle2));
    periods1(i) = period;
end
freq1 = 1/mean(periods1);
freq_err1 = std(1./periods1)/sqrt(length(trials1));

% Case 2: Equivalent mass
trials2 = {'clean_Lab7_EvB1.txt', 'clean_Lab7_EvB2.txt', 'clean_Lab7_EvB3.txt'}; 
periods2 = zeros(length(trials2), 1);
for i = 1:length(trials2)
    data = readtable(trials2{i});
    [period, ~, ~] = analyzeOscillations(data.Time, ...
        data.Position - mean(data.Position), ...
        data.Angle2 - mean(data.Angle2));
    periods2(i) = period;
end
freq2 = 1/mean(periods2);
freq_err2 = std(1./periods2)/sqrt(length(trials2));

% Case 3: With damping disc
trials3 = {'clean_Lab7_EvC1.txt', 'clean_Lab7_EvC2.txt', 'clean_Lab7_EvC3.txt'}; 
periods3 = zeros(length(trials3), 1);
for i = 1:length(trials3)
    data = readtable(trials3{i});
    [period, ~, ~] = analyzeOscillations(data.Time, ...
        data.Position - mean(data.Position), ...
        data.Angle2 - mean(data.Angle2));
    periods3(i) = period;
end
freq3 = 1/mean(periods3);
freq_err3 = std(1./periods3)/sqrt(length(trials3));

% Display results with mean frequencies and standard errors
results = table(...
    [mean(periods1); mean(periods2); mean(periods3)], ...
    [std(periods1)/sqrt(length(trials1)); std(periods2)/sqrt(length(trials2)); std(periods3)/sqrt(length(trials3))], ...
    [freq1; freq2; freq3], ...
    [freq_err1; freq_err2; freq_err3], ...
    'VariableNames', {'Period_s', 'Period_Error', 'Frequency_Hz', 'Freq_Error'}, ...
    'RowNames', {'No Disc', 'Equiv Mass', 'With Disc'});
disp('Results from multiple trials:')
disp(results)

% Plot frequency comparison with error bars
figure
errorbar(1:3, [freq1, freq2, freq3], [freq_err1, freq_err2, freq_err3], 'bo', 'MarkerFaceColor', 'b')
title('Frequency Comparison')
xticks(1:3)
xticklabels({'No Disc', 'Equiv Mass', 'With Disc'})
ylabel('Frequency (Hz)')
grid on

% Plot example oscillation data from one trial of each case
figure
plot(readtable(trials1{1}).Time, readtable(trials1{1}).Position - mean(readtable(trials1{1}).Position), 'b-', ...
     readtable(trials2{1}).Time, readtable(trials2{1}).Position - mean(readtable(trials2{1}).Position), 'r-', ...
     readtable(trials3{1}).Time, readtable(trials3{1}).Position - mean(readtable(trials3{1}).Position), 'g-')
title('Example Oscillation Data')
xlabel('Time (s)')
ylabel('Position (m)')
legend('No Disc', 'Equiv Mass', 'With Disc')
grid on

%%

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