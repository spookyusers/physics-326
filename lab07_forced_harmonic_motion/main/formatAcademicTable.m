function formatAcademicTable(data, tableNum, caption, filename, options)
    % FORMATACADEMICTABLE Creates a formatted academic-style table
    %   formatAcademicTable(data, tableNum, caption, filename, options)
    %
    % Inputs:
    %   data - table or matrix of numerical data to be formatted
    %   tableNum - table number (integer)
    %   caption - string containing table caption
    %   filename - output filename (without extension)
    %   options - struct with optional formatting parameters:
    %       .decimals - number of decimal places (default: 8)
    %       .colHeaders - cell array of column headers
    %       .footnote - string containing footnote text
    
    % Default options
    if nargin < 5
        options = struct();
    end
    if ~isfield(options, 'decimals')
        options.decimals = 8;
    end
    if ~isfield(options, 'footnote')
        options.footnote = '';
    end
    
    % Convert table to matrix if necessary
    if istable(data)
        if ~isfield(options, 'colHeaders')
            options.colHeaders = data.Properties.VariableNames;
        end
        data = table2array(data);
    end
    
    % Open file for writing
    fid = fopen([filename '.txt'], 'w');
    
    % Write table header and caption
    fprintf(fid, 'Table %d. %s\n', tableNum, caption);
    
    % Get dimensions
    [rows, cols] = size(data);
    
    % Create format string for numeric data
    numFormat = sprintf(' %%%d.%df', 12, options.decimals);
    
    % Write column headers if provided
    if isfield(options, 'colHeaders')
        % Write n column
        fprintf(fid, 'n');
        % Write remaining headers
        for j = 1:cols
            fprintf(fid, '    %-12s', options.colHeaders{j});
        end
        fprintf(fid, '\n');
        % Add separator line
        fprintf(fid, '%s\n', repmat('-', 1, 5 + cols * 16));
    end
    
    % Write data rows
    for i = 1:rows
        % Write row number
        fprintf(fid, '%d', i);
        % Write data values
        for j = 1:cols
            fprintf(fid, numFormat, data(i,j));
        end
        fprintf(fid, '\n');
    end
    
    % Add footnote if provided
    if ~isempty(options.footnote)
        fprintf(fid, '\n%s\n', options.footnote);
    end
    
    fclose(fid);
end