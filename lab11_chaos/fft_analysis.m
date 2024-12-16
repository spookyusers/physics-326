clear; clc; close all;

% Configuration
mainDir = './oscill_data'; 
known_frequencies = [10.813e3, 8.091e3, 5.406e3, 2.688e3];
% Set a very small threshold so we detect almost all peaks.
% Later you can raise this when you know what amplitude range to expect.
subharmonic_threshold = 1e-6; 

allFolders = dir(fullfile(mainDir, 'ALL*'));
all_V0 = [];
subharmonic_freqs = [];

for folderIdx = 1:length(allFolders)
    folderName = allFolders(folderIdx).name;
    folderPath = fullfile(mainDir, folderName);
    fprintf('\nProcessing Folder: %s\n', folderName);

    file_CH1 = fullfile(folderPath, sprintf('F%04dCH1.CSV', folderIdx - 1));
    file_CH2 = fullfile(folderPath, sprintf('F%04dCH2.CSV', folderIdx - 1));

    if ~isfile(file_CH1) || ~isfile(file_CH2)
        fprintf('Missing file in %s. Skipping.\n', folderName);
        continue;
    end

    % Read file line by line
    fid = fopen(file_CH1, 'r');
    if fid == -1
        fprintf('Could not open file: %s\n', file_CH1);
        continue;
    end
    rawLines = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
    fclose(fid);
    rawLines = rawLines{1};

    if isempty(rawLines)
        fprintf('File %s is empty or unreadable.\n', file_CH1);
        continue;
    end

    fprintf('First few lines of %s:\n', file_CH1);
    for i=1:min(5,numel(rawLines))
        disp(rawLines{i});
    end

    % Find start of numeric data by scanning lines
    dataStartLine = [];
    for r = 1:numel(rawLines)
        cols = split(rawLines{r}, ',');
        if numel(cols) >= 5
            val4 = str2double(strtrim(cols{4}));
            val5 = str2double(strtrim(cols{5}));
            if isfinite(val4) && isfinite(val5)
                dataStartLine = r;
                break;
            end
        end
    end

    if isempty(dataStartLine)
        fprintf('No numeric data rows found in %s.\n', file_CH1);
        continue;
    end

    numericData = [];
    for rr = dataStartLine:numel(rawLines)
        cols = split(rawLines{rr}, ',');
        if numel(cols) < 5, continue; end
        val4 = str2double(strtrim(cols{4}));
        val5 = str2double(strtrim(cols{5}));
        if ~isfinite(val4) || ~isfinite(val5)
            continue;
        end
        numericData = [numericData; val4, val5];
    end

    if isempty(numericData)
        fprintf('No numeric rows successfully parsed in %s.\n', file_CH1);
        continue;
    end

    time = numericData(:,1);
    voltage = numericData(:,2);

    if length(time) < 2
        fprintf('Insufficient numeric data points in %s.\n', file_CH1);
        continue;
    end

    % Compute FFT
    Fs = 1/(time(2)-time(1));
    N = length(voltage);
    Y = fft(voltage);
    P1 = abs(Y/N);
    P1 = P1(1:N/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(N/2))/N;

    if length(f) ~= length(P1)
        fprintf('Frequency and amplitude arrays differ in length for %s.\n', file_CH1);
        continue;
    end

    if any(~isfinite(P1)) || any(~isfinite(f))
        fprintf('Non-finite FFT data in %s. Skipping.\n', file_CH1);
        continue;
    end

    % Find peaks with a very low threshold
    try
        [pks, locs] = findpeaks(P1, f, 'MinPeakHeight', subharmonic_threshold);
    catch ME
        fprintf('Error using findpeaks on %s: %s\n', file_CH1, ME.message);
        continue;
    end

    fprintf('Detected peaks in %s:\n', file_CH1);
    if isempty(pks)
        disp('None detected');
    else
        pks = pks(:);
        locs = locs(:);
        disp([locs pks]);
    end

    % Broaden frequency tolerance to see if we can match known freqs
    tolerance = 500; % Hz
    detected_freqs = locs;
    matched_freqs = nan(size(known_frequencies));
    for i = 1:length(known_frequencies)
        if ~isempty(detected_freqs)
            [~, idx] = min(abs(detected_freqs - known_frequencies(i)));
            if abs(detected_freqs(idx)-known_frequencies(i)) < tolerance
                matched_freqs(i) = detected_freqs(idx);
            end
        end
        if isnan(matched_freqs(i))
            fprintf('Known freq %.3fkHz not detected.\n', known_frequencies(i)/1e3);
        else
            fprintf('Known freq %.3fkHz matched at %.3fkHz.\n', known_frequencies(i)/1e3, matched_freqs(i)/1e3);
        end
    end

    % Assign a dummy V0 value from index for demonstration
    V0 = folderIdx*0.1;
    all_V0(end+1,1) = V0;
    if ~isempty(locs)
        subharmonic_freqs(end+1,1) = max(locs);
    else
        subharmonic_freqs(end+1,1) = NaN;
    end

    figure(1);
    plot(f,P1,'DisplayName',sprintf('V_0=%.2fV',V0)); hold on;
    xlabel('Frequency (Hz)'); ylabel('Amplitude');
    title('FFT of V_R');
    legend show;
    drawnow;
end

figure(2);
scatter(all_V0, subharmonic_freqs,'filled');
xlabel('V_0 (V)'); ylabel('Subharmonic Frequency (Hz)');
title('Subharmonic Frequencies vs. V_0');
grid on;
fprintf('\nProcessing Complete.\n');
