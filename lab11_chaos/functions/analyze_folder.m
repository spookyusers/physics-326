function results = analyze_folder(folder_path)
    % Analyze voltage data from a single ALL folder
    % Input:
    %   folder_path: path to ALLxxxx folder containing clean_fxxxxch*.csv files
    % Output:
    %   results: structure containing analysis results
    
    % Get file paths
    ch1_file = dir(fullfile(folder_path, 'clean_*ch1.csv'));
    ch2_file = dir(fullfile(folder_path, 'clean_*ch2.csv'));
    
    if isempty(ch1_file) || isempty(ch2_file)
        error('Could not find channel files in folder: %s', folder_path);
    end
    
    % Read data
    V0_data = readmatrix(fullfile(folder_path, ch1_file(1).name), 'NumHeaderLines', 1);
    VR_data = readmatrix(fullfile(folder_path, ch2_file(1).name), 'NumHeaderLines', 1);
    
    % Extract time and voltage
    t = V0_data(:,1);
    V0 = V0_data(:,2);
    VR = VR_data(:,2);
    
    % Calculate basic statistics
    results.folder = folder_path;
    results.V0_mean = mean(V0);
    results.V0_rms = rms(V0);
    results.VR_mean = mean(VR);
    results.VR_rms = rms(VR);
    results.V0_range = [min(V0) max(V0)];
    results.VR_range = [min(VR) max(VR)];
    
    % Store raw data for additional analysis
    results.time = t;
    results.V0 = V0;
    results.VR = VR;
    
    % Calculate sampling frequency
    results.fs = 1/mean(diff(t));
end