function plotNormalizedPhaseDifference(data_case1, data_case2)
    % plotNormalizedPhaseDifference
    % Plots normalized phase diff vs norm angular freq for 2 damping cases
    %
    % Inputs:
    %   data_case1 - structure containing freq and phase for damp case1
    %   data_case2 - structure containing freq and phase for damp case2
    
     % Calculate normalized frequencies
    omega_bar_case1 = data_case1.Frequency / data_case1.omega0;
    omega_bar_case2 = data_case2.Frequency / data_case2.omega0;
    
    % Normalize phase differences
    phi_norm_case1 = data_case1.Phase / pi;  % Normalized to [-1, 0]
    phi_norm_case2 = data_case2.Phase / pi;
    
   % Plotting
    figure;
    hold on;
    plot(omega_bar_case1, phi_norm_case1, 'o-', 'DisplayName', 'Damping Case 1');
    plot(omega_bar_case2, phi_norm_case2, 's-', 'DisplayName', 'Damping Case 2');
    xlabel('Normalized Frequency \omega / \omega_0', 'FontSize', 14);
    ylabel('Normalized Phase Difference \phi/\pi', 'FontSize', 14);
    title('Normalized Phase Difference vs. Normalized Frequency', 'FontSize', 16);
    legend('Location', 'Best', 'FontSize', 12);
    grid on;
    hold off;
end