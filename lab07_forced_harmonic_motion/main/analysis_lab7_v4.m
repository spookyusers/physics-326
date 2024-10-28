% Kym Derriman
% Partner: Evan Howell
% Date: 10/28/2024
% Lab 07: Forced Harmonic Motion

%% Part 1 (A): Determine Natural Frequency

clc; clear; close all;

% Initialize data storage for table
data = {};

% Case 1: Without Damping Disk
% Import data
tbl = readtable("Lab7_EvA1.txt");
rotaryArmAngleData1 = tbl.Angle;
timeData1 = tbl.Time;
massPositionData1 = tbl.Position;

% Call the periodPhase_v2 function
[avgPeriod_NoDisk, periodError_NoDisk, phaseDiff_NoDisk] = periodPhase_v2(timeData1, massPositionData1, rotaryArmAngleData1);

% Calculate frequency
frequency_NoDisk = 1 / avgPeriod_NoDisk;

% Case 2: With Equivalent Mass of Disk
tbl = readtable("Lab7_EvA2.txt");
rotaryArmAngleData2 = tbl.Angle;
timeData2 = tbl.Time;
massPositionData2 = tbl.Position;
[avgPeriod_EquivMass, periodError_EquivMass, phaseDiff_EquivMass] = periodPhase_v2(timeData2, massPositionData2, rotaryArmAngleData2);
frequency_EquivMass = 1 / avgPeriod_EquivMass;

% Case 3: With Disk
tbl = readtable("Lab7_EvA3.txt");
rotaryArmAngleData3 = tbl.Angle;
timeData3 = tbl.Time;
massPositionData3 = tbl.Position;
[avgPeriod_WithDisk, periodError_WithDisk, phaseDiff_WithDisk] = periodPhase_v2(timeData3, massPositionData3, rotaryArmAngleData3);
frequency_WithDisk = 1 / avgPeriod_WithDisk;

% Print results
fprintf('--------------------------------------------------------------\n')
fprintf('Oscillation Results No Disk:\n')
fprintf('Average Period: %.4f +- %.4f seconds\n', avgPeriod_NoDisk, periodError_NoDisk);
fprintf('Frequency: %.4f Hertz\n', frequency_NoDisk);
fprintf('Phase Difference: %.4f radians\n', phaseDiff_NoDisk);

fprintf('--------------------------------------------------------------\n')
fprintf('Oscillation Results with Equivalent Mass:\n')
fprintf('Average Period: %.4f +- %.4f seconds\n', avgPeriod_EquivMass, periodError_EquivMass);
fprintf('Frequency: %.4f Hertz\n', frequency_EquivMass);
fprintf('Phase Difference: %.4f radians\n', phaseDiff_EquivMass);

fprintf('--------------------------------------------------------------\n')
fprintf('Oscillation Results with Disk:\n')
fprintf('Average Period with Disk: %.4f +- %.4f seconds\n', avgPeriod_WithDisk, periodError_WithDisk);
fprintf('Frequency No Disk: %.4f Hertz\n', frequency_WithDisk);
fprintf('Phase Difference: %.4f radians\n', phaseDiff_WithDisk);


%%







% --------------

% Voltages = [2,3.18,4.14,4.25,4.35,4.45,4.55,4.65,4.78,4.85,4.95,5.05,5.16,5.26,5.35,6,9.5];
% Amplitude = [];
% Phase = [];
% filename_Temp = "Lab7_%.2fV.txt";
% for V = Voltages
%     data = readtable(sprintf(filename_Temp,V));
%     pos = data.Position;
%     a = max(pos);
%     Amplitude(end+1) = a;
% 
% end

% -------------