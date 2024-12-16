% Script: Generate a Full Directory Map of All Files and Folders
clear; clc;

% Set the root directory path
rootDir = './'; % Replace with your specific path if needed
outputFile = 'directory_map.txt'; % Optional: Save output to a file

% Open a file for writing output
fileID = fopen(outputFile, 'w');
fprintf('Generating directory map for: %s\n', rootDir);
fprintf(fileID, 'Directory Map for: %s\n\n', rootDir);

% Function to recursively display the directory structure
function listDirectory(currentDir, indent, fileID)
    % List all files and folders in the current directory
    dirInfo = dir(currentDir);

    % Loop through each entry
    for i = 1:length(dirInfo)
        entryName = dirInfo(i).name;

        % Skip '.' and '..'
        if strcmp(entryName, '.') || strcmp(entryName, '..')
            continue;
        end

        % Print directory name with proper indentation
        entryPath = fullfile(currentDir, entryName);
        if dirInfo(i).isdir
            fprintf('%s[Folder] %s\n', indent, entryName);
            fprintf(fileID, '%s[Folder] %s\n', indent, entryName);
            % Recursively list subdirectory contents
            listDirectory(entryPath, [indent '    '], fileID);
        else
            fprintf('%s%s\n', indent, entryName);
            fprintf(fileID, '%s%s\n', indent, entryName);
        end
    end
end

% Start recursive directory listing from the root
listDirectory(rootDir, '', fileID);

% Close the output file
fclose(fileID);
fprintf('\nDirectory map saved to: %s\n', outputFile);
