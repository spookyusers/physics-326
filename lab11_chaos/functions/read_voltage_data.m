function [t, V0, VR] = read_voltage_data(ch1_file, ch2_file)
    % Read and process voltage data from cleaned CH1 and CH2 files
    % Inputs:
    %   ch1_file: path to cleaned CH1 file (V0 - driving voltage)
    %   ch2_file: path to cleaned CH2 file (VR - response voltage)
    % Outputs:
    %   t: time vector
    %   V0: driving voltage vector
    %   VR: response voltage vector
    
    % Read data
    ch1_data = readmatrix(ch1_file, 'NumHeaderLines', 1);  % Skip header
    ch2_data = readmatrix(ch2_file, 'NumHeaderLines', 1);
    
    % Extract time and voltage columns
    t = ch1_data(:, 1);
    V0 = ch1_data(:, 2);
    VR = ch2_data(:, 2);
    
    % Ensure same length
    min_length = min(length(V0), length(VR));
    t = t(1:min_length);
    V0 = V0(1:min_length);
    VR = VR(1:min_length);
end