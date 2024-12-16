function [V0_amps, VR_values] = process_all_folders()
    % Process all oscilloscope data folders
    % Output: V0_amps - array of V0 amplitudes
    %         VR_values - cell array of VR peak values for each amplitude
    
    % Initialize arrays
    V0_amps = [];
    VR_values = {};
    
    % Loop through folders (ALL0000 to ALL0014)
    for folder_num = 0:14
        try
            % Read data
            [time, V0, VR] = read_scope_data(folder_num);
            
            % Get peaks
            [VR_peaks, V0_amp] = find_VR_at_V0_peaks(time, V0, VR);
            
            % Store results
            V0_amps(end+1) = V0_amp;
            VR_values{end+1} = VR_peaks;
            
            fprintf('Processed folder ALL%04d\n', folder_num);
        catch ME
            fprintf('Error processing folder ALL%04d: %s\n', folder_num, ME.message);
        end
    end
end