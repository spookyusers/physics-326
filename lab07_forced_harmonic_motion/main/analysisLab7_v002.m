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
