function a_threshold = find_threshold(a_low, a_high, target_period, x0, n_iterations, n_check)
    % Function to count unique values in steady state
    function n_unique = count_period(a)
        x = logistic(x0, a, n_iterations);
        last_values = unique(round(x(end-n_check:end), 6));
        n_unique = length(last_values);
    end

    tolerance = 1e-6;
    while (a_high - a_low) > tolerance
        a_mid = (a_low + a_high) / 2;
        if count_period(a_mid) <= target_period
            a_low = a_mid;
        else
            a_high = a_mid;
        end
    end
    a_threshold = (a_low + a_high) / 2;
end