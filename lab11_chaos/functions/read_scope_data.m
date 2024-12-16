function [time, V0, VR] = read_scope_data(folder_num)
    % Get the directory where this function file is located
    func_dir = fileparts(mfilename('fullpath'));
    % Get the project root directory (parent of functions directory)
    project_dir = fileparts(func_dir);
    % Path to data directory
    data_dir = fullfile(project_dir, 'oscill_data');
    
    % Construct file paths
    folder_name = sprintf('ALL%04d', folder_num);
    ch1_file = fullfile(data_dir, folder_name, sprintf('F%04dCH1.CSV', folder_num));
    ch2_file = fullfile(data_dir, folder_name, sprintf('F%04dCH2.CSV', folder_num));
    
    % Read data files
    data1 = readmatrix(ch1_file);
    data2 = readmatrix(ch2_file);
    
    % Extract data columns
    time = data1(:,4);  % Time column
    V0 = data1(:,5);    % Voltage from CH1
    VR = data2(:,5);    % Voltage from CH2
end