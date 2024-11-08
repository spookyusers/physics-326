function F0 = calculateForceAmplitude(angle_amplitudes)
    % Assuming the force amplitude F0 is proportional to the average angle amplitude
    % Adjust the proportionality constant kappa based on your experimental setup
    kappa = 1; % Placeholder value; replace with actual value if known
    F0 = kappa * mean(angle_amplitudes);
end
