% Kym Derriman
% Partner: Evan Howell
% Date: 10/28/2024
% Lab 07: Forced Harmonic Motion

%% Part 1 (A): Determine Natural Frequency

%% Case 1: Without Damping Disk
% Set in motion, record with LP. Measure period w ML.
% Time over 10 periods. Repeat several times.
% Estimate error.

% Import data
tbl = readtable("Lab7_EvA1.txt");
rotaryArmAngleData1 = tbl.Angle; % rotary arm angle data
timeData1 = tbl.Time; % time array (same for both x and theta)
massPositionData1 = tbl.Position; % position of the mass from ultrasonic sensor

% Call the periodPhasev1 function
[avgPeriod_NoDisk, periodError_NoDisk, phaseDiff_NoDisk, ~] = periodPhase_v2(timeData1, massPositionData1, rotaryArmAngleData1);

% Calculate frequency
frequency_NoDisk = 1 / avgPeriod_NoDisk;

% Print only the results you need
fprintf('--------------------------------------------------------------\n')
fprintf('Oscillation Results No Disk:\n')
fprintf('Average Period: %.4f +- %.4f seconds\n', avgPeriod_NoDisk, periodError_NoDisk);
fprintf('Frequency: %.4f Hertz\n', frequency_NoDisk);
fprintf('Phase Difference: %.4f radians\n', phaseDiff_NoDisk);


%% Case 2: With equivalent mass of disk

% Measure period/phase with equivalent mass to disk

% Import data
tbl = readtable("Lab7_EvA2.txt");
rotaryArmAngleData2 = tbl.Angle; % rotary arm angle data
timeData2 = tbl.Time; % time array (same for both x and theta)
massPositionData2 = tbl.Position; % position of the mass from ultrasonic sensor

% Call the periodPhasev1 function
[avgPeriod_EquivMass, periodError_EquivMass, phaseDiff_EquivMass, ~] = periodPhase_v2(timeData2, massPositionData2, rotaryArmAngleData2);

% Calculate frequency
frequency_EquivMass = 1 / avgPeriod_EquivMass;

% Print only the results you need
fprintf('--------------------------------------------------------------\n')
fprintf('Oscillation Results with Equivalent Mass:\n')
fprintf('Average Period: %.4f +- %.4f seconds\n', avgPeriod_EquivMass, periodError_EquivMass);
fprintf('Frequency: %.4f Hertz\n', frequency_EquivMass);
fprintf('Phase Difference: %.4f radians\n', phaseDiff_EquivMass);


%% Case 3: With disk

% Measure period/phase with disk

% Import data
tbl = readtable("Lab7_EvA3.txt");
rotaryArmAngleData3 = tbl.Angle; % rotary arm angle data
timeData3 = tbl.Time; % time array (same for both x and theta)
massPositionData3 = tbl.Position; % position of the mass from ultrasonic sensor

% Call the periodPhasev1 function
[avgPeriod_WithDisk, periodError_WithDisk, phaseDiff_WithDisk, ~] = periodPhase_v2(timeData3, massPositionData3, rotaryArmAngleData3);

% Calculate frequency
frequency_WithDisk = 1 / avgPeriod_WithDisk;

% Print only the results you need
fprintf('--------------------------------------------------------------\n')
fprintf('Oscillation Results with Disk:\n')
fprintf('Average Period with Disk: %.4f +- %.4f seconds\n', avgPeriod_WithDisk, periodError_WithDisk);
fprintf('Frequency No Disk: %.4f Hertz\n', frequency_WithDisk);
fprintf('Phase Difference: %.4f radians\n', phaseDiff_WithDisk);
