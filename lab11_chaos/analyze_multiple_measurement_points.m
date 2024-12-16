% Test script to analyze multiple measurement points
clear; clc; close all;

% Try a sequence of folders to see progression
folders_to_test = [0 1 7 10 15];  % Choose some spread-out folders
n_plots = length(folders_to_test);

figure('Position', [100 100 1500 300*n_plots]);

for i = 1:length(folders_to_test)
    folder_num = folders_to_test(i);
    [time, V0, VR] = read_scope_data(folder_num);
    V0_amp = mean(abs(findpeaks(V0, 'MinPeakDistance', 10)));
    
    % Plot phase space (Lissajous) for each
    subplot(n_plots, 2, 2*i-1)
    plot(V0, VR, 'b.', 'MarkerSize', 1)
    title(sprintf('Phase Space: V0 amp = %.4f V', V0_amp))
    xlabel('V0')
    ylabel('VR')
    grid on
    
    % Plot VR distribution
    subplot(n_plots, 2, 2*i)
    histogram(VR, 50, 'Normalization', 'probability')
    title('VR Distribution')
    xlabel('VR')
    ylabel('Probability')
    grid on
    
    fprintf('Folder %d - V0 amplitude: %.4f V\n', folder_num, V0_amp);
end