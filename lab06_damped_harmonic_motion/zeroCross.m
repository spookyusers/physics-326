% -----------------------------------------------------------------
% Function to find zero crossings
% -----------------------------------------------------------------
function [crossing_times, crossing_indices] = find_zero_crossings(data, times)
    % Identify zero-crossings
    zero_crossings = (data(1:end-1) .* data(2:end)) < 0;
    % Extract the times at which zero-crossings occur
    crossing_indices = find(zero_crossings);
    crossing_times = times(crossing_indices);
end