% Analysis Lab7 Week2

% --- A-E No Mass ---

mass_plate = 0.01;
mass_total = 0.5274;
mass_additional = mass_total - mass_plate;
disp(mass_additional);

%%

data = readtable('Lab7_Wk2_noMass.txt');
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

% --- A-E for Equiv Mass ---

data = readtable('Lab7_Wk2_EquivMass.txt');
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

% --- A-E Small Paper Plate ---
data = readtable('Lab7_Wk2_SmallPlate.txt');
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

%% Different voltages around resonance

clear;close all; clc;
% found resonance around 5v

%Data
withPlateVoltages = [468, 478, 492, 501, 504, 506, 507, 510, 513, 515, 516, 520, 524, 525, 527, 530, 538];

% Initialize arrays
Amplitude = zeros(size(withPlateVoltages));
Phase = zeros(size(withPlateVoltages));
Frequencies = zeros(size(withPlateVoltages));
Vmax = zeros(size(withPlateVoltages));

% Loop through voltages
for i = 1:length(withPlateVoltages)
    V = withPlateVoltages(i);
    % Read data - note the "clean_" prefix
    filename = sprintf("%dV.txt", V);
    data = readtable(filename);
    time = data.Time;
    position = data.Position;
    angle = data.Angle2;
    position_centered = position - mean(position);
    angle_centered = angle - mean(angle);

    peakTimes = [];
    peakPositions = [];
    peakAngles = [];
    
    % peak detection: a point is a peak if it's greater than its neighbors
    for i = 2:length(position_centered)-1
        if position_centered(i) > position_centered(i-1) && position_centered(i) > position_centered(i+1)
            peakTimes(end+1) = time(i); 
            peakPositions(end+1) = position(i); %#ok<*SAGROW>
        end
    end
    
    for i = 2:length(angle_centered)-1
        if angle_centered(i) > angle_centered(i-1) && angle_centered(i) > angle_centered(i+1)
            peakAngleTimes(end+1) = time(i);
            peakAngles(end+1) = angle_centered(i);
        end
    end
    

    % Calculate periods between successive peaks
    period = diff(peakTimes);
    period_error = std(period);
    phaseDiffs = peakTimes - peakAngleTimes;

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
results = table(withPlateVoltages', Frequencies', Amplitude', Phase', Vmax', ...
    'VariableNames', {'Voltage', 'Frequency', 'Amplitude', 'Phase', 'Vmax'});
disp(results)