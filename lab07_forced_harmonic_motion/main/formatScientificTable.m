function formatScientificTable(data, filename, varargin)
    % Format a MATLAB table for scientific publication
    % 
    % Parameters:
    % data: MATLAB table object
    % filename: output filename (without extension)
    % varargin: Name-value pairs for formatting options
    %   'Format': 'latex' (default) or 'csv'
    %   'Precision': number of decimal places (default: 3)
    %   'Caption': table caption
    %   'Label': table label for LaTeX
    
    p = inputParser;
    addRequired(p, 'data', @istable);
    addRequired(p, 'filename', @ischar);
    addParameter(p, 'Format', 'latex', @ischar);
    addParameter(p, 'Precision', 3, @isnumeric);
    addParameter(p, 'Caption', '', @ischar);
    addParameter(p, 'Label', '', @ischar);
    parse(p, data, filename, varargin{:});
    
    % Get variable names and size
    varNames = data.Properties.VariableNames;
    [rows, cols] = size(data);
    
    if strcmpi(p.Results.Format, 'latex')
        % Open file for writing
        fid = fopen([filename '.tex'], 'w');
        
        % Begin LaTeX table environment
        fprintf(fid, '\\begin{table}[htbp]\n');
        fprintf(fid, '\\centering\n');
        
        % Add caption if provided
        if ~isempty(p.Results.Caption)
            fprintf(fid, '\\caption{%s}\n', p.Results.Caption);
        end
        
        % Add label if provided
        if ~isempty(p.Results.Label)
            fprintf(fid, '\\label{%s}\n', p.Results.Label);
        end
        
        % Begin tabular environment with column alignment
        fprintf(fid, '\\begin{tabular}{%s}\n', ['l' repmat('c', 1, cols-1)]);
        fprintf(fid, '\\toprule\n');
        
        % Write header
        fprintf(fid, '%s', varNames{1});
        for j = 2:cols
            fprintf(fid, ' & %s', varNames{j});
        end
        fprintf(fid, ' \\\\\n');
        fprintf(fid, '\\midrule\n');
        
        % Write data
        for i = 1:rows
            for j = 1:cols
                val = data{i,j};
                % Format based on data type
                if isnumeric(val)
                    if j == 1
                        fprintf(fid, '%g', round(val, p.Results.Precision));
                    else
                        fprintf(fid, ' & %g', round(val, p.Results.Precision));
                    end
                else
                    if j == 1
                        fprintf(fid, '%s', char(val));
                    else
                        fprintf(fid, ' & %s', char(val));
                    end
                end
            end
            fprintf(fid, ' \\\\\n');
        end
        
        % End LaTeX table
        fprintf(fid, '\\bottomrule\n');
        fprintf(fid, '\\end{tabular}\n');
        fprintf(fid, '\\end{table}\n');
        
    else % CSV format
        writetable(data, [filename '.csv'], ...
            'Delimiter', ',', ...
            'WriteRowNames', true);
    end
    
    if fid ~= -1
        fclose(fid);
    end
end