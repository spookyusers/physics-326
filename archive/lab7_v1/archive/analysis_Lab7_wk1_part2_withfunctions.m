% ProcessForcedOscillationData.m

%% Initialization
voltages = [3.18, 4.14, 4.25, 4.35, 4.45, 4.55, 4.65, 4.78, 4.85, ...
            4.95, 5.05, 5.16, 5.26, 5.35, 6.00, 9.50];
dataFolder = ''; % Specify the data folder if needed

%% Data Processing
results_table = processAllVoltages(voltages, dataFolder);

%% Display Results
disp(results_table);

%% Plotting
plotAmplitudeVsFrequency(results_table.Frequency, results_table.Amplitude);
plotVelocityVsFrequency(results_table.Frequency, results_table.Vmax);
