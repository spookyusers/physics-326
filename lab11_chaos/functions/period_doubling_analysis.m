function period_doubling_analysis
    % Parameters
    n_iterations = 1000;  % Iterations to reach steady state
    n_check = 50;        % Number of points to check for periodicity
    x0 = 0.5;           % Initial condition
    
    % Function to count unique values in steady state
    function n_unique = count_period(a)
        x = logistic(x0, a, n_iterations);
        last_values = unique(round(x(end-n_check:end), 6));
        n_unique = length(last_values);
    end
    
    % Function to binary search for transition point
    function a_threshold = find_threshold(a_low, a_high, target_period)
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
    
    % Initial guesses for period doubling regions
    a_ranges = [
        2.99, 3.01;    % Period 1 to 2
        3.44, 3.45;    % Period 2 to 4
        3.54, 3.55;    % Period 4 to 8
        3.56, 3.57     % Period 8 to 16
    ];
    
    % Find thresholds
    a_values = zeros(4, 1);
    for i = 1:4
        a_values(i) = find_threshold(a_ranges(i,1), a_ranges(i,2), 2^i);
        
        % Verify by plotting before and after
        figure;
        subplot(2,1,1);
        x_before = logistic(x0, a_values(i)-0.0001, n_iterations);
        plot(x_before(end-50:end), 'o-');
        title(sprintf('Just before a_%d = %.4f', i, a_values(i)));
        ylim([0 1]);
        
        subplot(2,1,2);
        x_after = logistic(x0, a_values(i)+0.0001, n_iterations);
        plot(x_after(end-50:end), 'o-');
        title(sprintf('Just after a_%d = %.4f', i, a_values(i)));
        ylim([0 1]);
    end
    
    % Calculate differences and Feigenbaum constant
    differences = diff(a_values);
    delta = differences(1:end-1) ./ differences(2:end);
    
    % Calculate a_infinity and S using Eqs 2-4
    delta_avg = mean(delta);
    k = length(a_values);
    a_infinity = a_values(k) + differences(k-1) * delta_avg / (delta_avg - 1);
    S = (differences(k-1) * delta_avg^k) / (delta_avg - 1);
    
    % Print results
    fprintf('Period Doubling Analysis Results:\n');
    fprintf('k\ta_k\t\ta_(k+1)-a_k\tdelta_k\n');
    fprintf('1\t%.4f\t%.4f\t--\n', a_values(1), differences(1));
    for i = 2:length(a_values)-1
        fprintf('%d\t%.4f\t%.4f\t%.4f\n', i, a_values(i), differences(i), delta(i-1));
    end
    fprintf('%d\t%.4f\t%.4f\t%.4f\n', length(a_values), a_values(end), differences(end), delta(end));
    fprintf('\nEstimated a_infinity: %.4f\n', a_infinity);
    fprintf('Estimated S: %.4f\n', S);
end