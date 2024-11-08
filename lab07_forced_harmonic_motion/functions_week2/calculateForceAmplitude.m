function F0 = calculateForceAmplitude(angle_amplitudes)
    kappa = 1;
    F0 = kappa * mean(angle_amplitudes);
end
