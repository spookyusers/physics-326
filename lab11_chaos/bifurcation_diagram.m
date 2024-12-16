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

            % Find peaks in VR
            peaks = find_VR_at_V0_peaks(time, V0, VR);

            % Calculate V0 amplitude
            V0_amp = (max(V0) - min(V0)) / 2;

            % Store results
            V0_amps(end+1) = V0_amp;
            VR_values{end+1} = peaks;
        catch
            % Skip folders that don't exist or have missing files
            continue;
        end
    end

    % Sort the data by V0 amplitude
    [V0_sorted, sort_idx] = sort(V0_amps);
    VR_sorted = VR_values(sort_idx);

    % Create figure
    figure('Position', [100 100 1000 800]);
    hold on;

    % Plot each set
    for i = 1:length(V0_sorted)
        vr = VR_sorted{i};
        if ~isempty(vr)
            x = repmat(V0_sorted(i), size(vr));
            plot(x, vr, 'k.', 'MarkerSize', 1);
        end
    end

    xlabel('V0 Amplitude (V)');
    ylabel('VR Peak Values');
    title('RLC Circuit Bifurcation Diagram');
    grid on;

    % Set axis limits
    if ~isempty(V0_sorted)
        xlim([min(V0_sorted)*0.9 max(V0_sorted)*1.1]);
        ylim([min(cellfun(@min, VR_sorted)) max(cellfun(@max, VR_sorted))]);
    end

catch ME
    fprintf('Error: %s\n', ME.message);
end
