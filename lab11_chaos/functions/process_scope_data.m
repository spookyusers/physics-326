function [V0_peaks, VR_values] = process_scope_data(filename)
    % Read oscilloscope data file
    % Input: filename - path to the oscilloscope data file
    % Output: V0_peaks - peaks of driving voltage
    %         VR_values - VR values at V0 peaks
    
    % Read the data
    data = readmatrix(filename);
    time = data(:,1);
    V0 = data(:,2);  % Driving voltage
    VR = data(:,3);  % Response voltage
    
    % Find peaks of V0 to determine period
    [~, peak_indices] = findpeaks(V0, 'MinPeakHeight', max(V0)*0.8);
    
    % Get VR values at V0 peaks
    VR_values = VR(peak_indices);
    V0_peaks = V0(peak_indices);
end