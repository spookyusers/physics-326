%% Remember that part 1 no driving force!!! Only analyze position!!!

% Lab 7

% --- Case 1: Equivalent Mass ---

data = readtable('./cleandata/clean_Lab7_EvA1.txt');
time = data.Time;
posData = data.Position;
shifted_pos = posData - mean(posData);
% Zero Crossing Times
positivePositions = shifted_pos >= 0;
negativePositions = shifted_pos< 0;
zeroCrossingInd = positivePositions(1:end-1) & negativePositions(2:end);
zeroCrossingTimes = time(zeroCrossingInd);
% Period
T_disk = zeroCrossingTimes(1:2:end);
T_avg_disk = mean(T_disk);
% Frequency
frequency_disk = 1 / T_avg_disk;

% --- Case 2: No Mass ---

data = readtable('./cleandata/clean_Lab7_EvB1.txt');
time = data.Time;
posData = data.Position;
shifted_pos = posData - mean(posData);
% Zero Crossing Times
positivePositions = shifted_pos >= 0;
negativePositions = shifted_pos< 0;
zeroCrossingInd = positivePositions(1:end-1) & negativePositions(2:end);
zeroCrossingTimes = time(zeroCrossingInd);
% Period
T_equiv_mass = zeroCrossingTimes(1:2:end);
T_avg_equiv_mass = mean(T_equiv_mass);
% Frequency
frequency_equiv_mass = 1 / T_avg_equiv_mass;

% --- Case 3: Disk ---
data = readtable('./cleandata/clean_Lab7_EvC1.txt');
time = data.Time;
posData = data.Position;
shifted_pos = posData - mean(posData);
% Zero Crossing Times
positivePositions = shifted_pos >= 0;
negativePositions = shifted_pos< 0;
zeroCrossingInd = positivePositions(1:end-1) & negativePositions(2:end);
zeroCrossingTimes = time(zeroCrossingInd);
% Period
T_no_mass = zeroCrossingTimes(1:2:end);
T_avg_no_mass = mean(T_no_mass);
% Frequency
frequency_no_mass = 1 / T_avg_no_mass;


% Print results
fprintf('--------------------------------------------------------------\n')
fprintf('Frequency No Mass: %.4f Hertz\n', frequency_no_mass);
fprintf('Frequency Equivalent Mass: %.4f Hertz\n', frequency_equiv_mass);
fprintf('Frequency With Disk: %.4f Hertz\n', frequency_disk);

%% Part B

%Data
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
    filename = sprintf("/./cleandata/clean_Lab7_%.2fV.txt", V);
    data = readtable(filename);
    
    time = data.Time;
    position = data.Position;
    angle = data.Angle2;
    
    position_centered = position - mean(position);
    %angle_centered = angle - mean(angle);
    [period, ~, phase] = analyzeOscillations(time, position_centered, angle); %angle_centered);
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
