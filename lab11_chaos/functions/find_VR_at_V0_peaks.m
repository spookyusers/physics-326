function [VR_peaks] = find_VR_at_V0_peaks(time, V0, VR)
    % Find both positive and negative peaks of VR
    % Input: time, V0, VR arrays from oscilloscope data
    % Output: VR_peaks - all peak values (positive and negative)
    
    % Find both positive and negative peaks
    [pos_pks, ~] = findpeaks(VR, 'MinPeakDistance', 10);
    [neg_pks, ~] = findpeaks(-VR, 'MinPeakDistance', 10);
    neg_pks = -neg_pks;  % Convert back to actual negative values
    
    % Combine all peaks
    VR_peaks = [pos_pks; neg_pks];
end