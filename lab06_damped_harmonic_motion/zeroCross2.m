function [crossTimes, crossIndices, crossingDirections] = zeroCross2(signal, time)
    % Initialize arrays
    crossTimes = [];
    crossIndices = [];
    crossingDirections = []; % +1 for negative-to-positive, -1 for positive-to-negative

    for i = 1:length(signal)-1
        if signal(i) == 0
            crossTimes = [crossTimes; time(i)];
            crossIndices = [crossIndices; i];
            crossingDirections = [crossingDirections; 0]; % Exact zero, direction undefined
        elseif signal(i)*signal(i+1) < 0
            % Zero crossing between i and i+1
            % Linear interpolation to find the zero crossing time
            zeroCrossTime = time(i) - signal(i)*(time(i+1)-time(i))/(signal(i+1)-signal(i));
            crossTimes = [crossTimes; zeroCrossTime];
            crossIndices = [crossIndices; i];
            % Determine the direction
            if signal(i) > 0 && signal(i+1) < 0
                crossingDirections = [crossingDirections; -1]; % Positive to negative
            else
                crossingDirections = [crossingDirections; +1]; % Negative to positive
            end
        end
    end
end
