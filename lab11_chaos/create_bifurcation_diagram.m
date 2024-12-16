% Create bifurcation diagram
clear; clc; close all;

try
    % Initialize arrays
    V0_amps = [];
    VR_values = {};
    
    % Process folders
    for folder_num = 0:51
        try
            % Read data
            [time, V0, VR] = read_scope_data(folder_num);
            
            % Find peaks
            peaks = find_VR_at_V0_peaks(time, V0, VR);
            
            % Calculate V0 amplitude
            V0_amp = mean(abs(findpeaks(V0, 'MinPeakDistance', 10)));
            
            % Store results
            V0_amps(end+1) = V0_amp;
            VR_values{end+1} = peaks;
            
        catch
            % Silently skip folders that don't exist or have missing files
            continue
        end
    end
    
    % Sort the data by V0 amplitude
    [V0_sorted, sort_idx] = sort(V0_amps);
    VR_sorted = VR_values(sort_idx);
    
    % Create figure
    figure('Position', [100 100 1000 800])
    hold on
    
    % Plot each set
    for i = 1:length(V0_sorted)
        vr = VR_sorted{i};
        if ~isempty(vr)
            % Add small random jitter to x values for better visibility
            x = V0_sorted(i) + randn(size(vr))*0.0001;
            plot(x, vr, 'k.', 'MarkerSize', 1)
        end
    end
    
    xlabel('V0 Amplitude (V)')
    ylabel('VR Values')
    title('RLC Circuit Bifurcation Diagram')
    grid on
    
    % Set axis limits
    if ~isempty(V0_sorted)
        xlim([min(V0_sorted)*0.9 max(V0_sorted)*1.1])
        ylim([-4 4])
    end
    
catch ME
    fprintf('Error: %s\n', ME.message)
end