%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Histogram with Gaussian Overlay Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Kym Derriman
% Date 10/3/2024

%This function allows you to plot a histogram and overlay a Gaussian curve
%from imported data. You have to import a numeric vector, and you can
%specify a fixed bin width or a bin width that is a multiplier of the
%standard error of sigma N. As written, it must be used with "formatfig.m"
%If you don't want this, comment it out.


function histoGauss = histoGauss(data, varargin)
    
    % Validate that 'data' is a numeric vector
    if ~isnumeric(data) || ~isvector(data)
        error('Input "data" must be a numeric vector.');
    end

    % Parse Name-Value Pair Arguments
    p = inputParser;
    addParameter(p, 'BinWidth', 1, @(x) isnumeric(x) && x > 0);
    addParameter(p, 'UseSigmaMultiplier', false, @(x) islogical(x) || (isnumeric(x) && (x == 0 || x == 1)));
    addParameter(p, 'BinWidthMultiplier', 1, @(x) isnumeric(x) && x > 0);
    parse(p, varargin{:});

    bin_width_fixed = p.Results.BinWidth;
    use_sigma_multiplier = p.Results.UseSigmaMultiplier;
    bin_width_multiplier = p.Results.BinWidthMultiplier;

    % Analyze data
    N_Sample = length(data);
    delta_t = 0.5;
    Nbar = mean(data);
    Sigma_N = std(data);
    R_best = Nbar / delta_t;
    Sigma_R = (Sigma_N / sqrt(N_Sample)) / delta_t;

    % Determine bin width
    if use_sigma_multiplier
        bin_width = bin_width_multiplier * Sigma_N;
    else
        bin_width = bin_width_fixed;
    end

    % Define bin edges based on bin width
    min_val = floor(min(data));
    max_val = ceil(max(data));
    bin_edges = min_val:bin_width:max_val + bin_width; % Ensure inclusion of max data point

    % Get counts and centers using histcounts
    counts = histcounts(data, bin_edges);
    centers = bin_edges(1:end-1) + bin_width / 2;

    % Normalize counts
    probabilities = counts / N_Sample;

    % Plot the histogram
    bar(centers, probabilities, 'EdgeColor', 'w', 'FaceColor', '#0072BD');
    hold on; % Allows multiple histograms to be plotted on the same figure
    
    % Assign outputs to the structure
    histoGauss.counts = counts;
    histoGauss.centers = centers;
    histoGauss.probabilities = probabilities;
    histoGauss.best = R_best;
    histoGauss.sigmaR = Sigma_R;

    % Plot Gaussian distribution  
    y_norm = normpdf(centers, Nbar, Sigma_N) *bin_width;
    color_norm = 'r';
    plot(centers, y_norm, '-', 'Color', color_norm)

    % Format figure for better visibility 
    formatfig(gcf, 'line', 'stretch',[0.9, 0.9])
    box('off')
    title('$\bar{N} (n) \pm \sigma_{\bar{N}} (= \sigma/\sqrt{n})$', 'FontSize', 16, 'Interpreter', 'latex');
    xlabel('Number of data points (n)', 'FontSize', 16);
    ylabel('Mean Radiation Count', 'FontSize', 16);
    pos_old = get(gca, 'Position');
    pos_new = [pos_old(1:3), 0.72];
    set(gca, 'Position', pos_new);
end