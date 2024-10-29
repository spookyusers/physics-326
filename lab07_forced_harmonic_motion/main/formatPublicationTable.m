function formatPublicationTable(data, tableNum, caption, filename)
    % FORMATPUBLICATIONTABLE Creates publication-quality table in HTML format
    % Input:
    %   data - matrix of numbers to format
    %   tableNum - table number
    %   caption - table caption
    %   filename - name for output file
    
    % Create HTML file
    fid = fopen([filename '.html'], 'w');
    
    % Write HTML header with styling
    fprintf(fid, ['<!DOCTYPE html>\n' ...
                  '<html>\n<head>\n' ...
                  '<style>\n' ...
                  'table { border-collapse: collapse; width: 100%%; }\n' ...
                  'th, td { padding: 8px; text-align: right; }\n' ...
                  'th { border-bottom: 2px solid black; }\n' ...
                  'tr:last-child td { border-bottom: 1px solid black; }\n' ...
                  'caption { font-weight: bold; margin-bottom: 10px; text-align: left; }\n' ...
                  '</style>\n</head>\n<body>\n']);
    
    % Start table
    fprintf(fid, '<table>\n');
    
    % Add caption
    fprintf(fid, '<caption>Table %d. %s</caption>\n', tableNum, caption);
    
    % Write data
    [rows, cols] = size(data);
    
    % Write each row
    for i = 1:rows
        fprintf(fid, '<tr>\n');
        fprintf(fid, '<td>%d</td>\n', i);  % Row number
        for j = 1:cols
            fprintf(fid, '<td>%.8f</td>\n', data(i,j));
        end
        fprintf(fid, '</tr>\n');
    end
    
    % Close table and HTML
    fprintf(fid, '</table>\n</body>\n</html>');
    
    fclose(fid);
    
    % Also create LaTeX version
    fid = fopen([filename '.tex'], 'w');
    
    % Write LaTeX header
    fprintf(fid, '\\begin{table}[htbp]\n');
    fprintf(fid, '\\caption{%s}\n', caption);
    fprintf(fid, '\\begin{tabular}{r%s}\n', repmat('r', 1, cols));
    fprintf(fid, '\\toprule\n');
    
    % Write data
    for i = 1:rows
        fprintf(fid, '%d', i);
        for j = 1:cols
            fprintf(fid, ' & %.8f', data(i,j));
        end
        fprintf(fid, ' \\\\\n');
    end
    
    % Close LaTeX table
    fprintf(fid, '\\bottomrule\n');
    fprintf(fid, '\\end{tabular}\n');
    fprintf(fid, '\\end{table}\n');
    
    fclose(fid);
end