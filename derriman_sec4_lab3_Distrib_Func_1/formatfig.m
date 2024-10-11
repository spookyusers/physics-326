%    
% NAME:
% 	formatfig
%
% PURPOSE:
%	Format 
%
% EXAMPLE USAGE:
%	formatfig(gcf, 'line', 'stretch', [0.8, 0.8]);

%
% MODIFICATION HISTORY:
% 	Created by S.H. Lee, Rutgers University
%
%
% 	%  Copyright (c) 2024 Sang-Hyuk Lee                                                                     
%
% LICENSE:
%    This program is free software; you can redistribute it and/or
%    modify it under the terms of the GNU General Public License as
%    published by the Free Software Foundation; either version 2 of the
%    License, or (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%    General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; if not, write to the Free Software
%    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
%    02111-1307 USA
%
%    If the Internet and WWW are still functional when you are using
%    this, you shold be able to access the GPL here: 
%    http://www.gnu.org/copyleft/gpl.html
%-    

function formatfig(hf, figType, varargin)
% INPUT 
% 	hf: Figure handle. If not provided, the setup is applied to all the open figures.
% 	figType: 'line' or 'image'. 
%
% OPTIONAL INPUT (Name-Value pair arguments)
% 	
% 	'size' -  size of figures [width, height] (default: [448, 326])
% 	'stretch' - stretching factor [x-scaling, y-scaling] (default: [1, 1])

switch lower(figType)
   case 'line'
      rendererType = 'painter';
   case 'image'
      rendererType = 'opengl';
   otherwise
      error('Figure type unidentified. It should be either ''line'' or ''image''. ');
end


% Get all the open figure handles if a specific figure handle is not provided
if nargin == 0
   hf = findobj('Type', 'Figure');
else
   % Check if input is an array of figure handle
   if ~all(isgraphics(hf, 'figure')) 
      error('The input should be an array of figure handle');
   end
end

% Default parameter values
figSize =  [448, 336];
flagOriginalSize = false;

% Default figure resizing factor
stretchFactor = [1, 1];

% Optional Input
for i=1:2:numel(varargin)
   val = varargin{i+1};
   switch lower(varargin{i})
      case 'size'
	 if isempty(val)
	    flagOriginalSize = true;
	 elseif isnumeric(val) & numel(val) == 2
	    figSize = val;
	 else
	    warning('Input figure size format is wrong. Using the default figure size');
	 end
      case 'stretch'
	 if isnumeric(val) & numel(val) == 2
	    stretchFactor = val;
	 else
	    warning('Figure resizing format is wrong. Using the default figure size');
	 end
   end % switch
end

figSize = round(figSize .* stretchFactor);

nFig = numel(hf);

for i=1:nFig

   % Get axis handle
   hx = findobj(get(hf(i), 'Children'), 'Type', 'axes');

   if numel(hx) > 1
      error('Multiple axes not supported');
   end
   % Save axis limit to preserve
   xlim = hx.XLim;
   ylim = hx.YLim;


   hf(i).Units = 'points';
   hf(i).Color = [1, 1, 1]; 
   hf(i).Renderer = rendererType; 

   if ~flagOriginalSize
      hf(i).Position(3:4) = figSize;
   end

   set(findall(hf(i), '-property', 'FontSize'), 'FontSize', 16);
   set(findall(hf(i), '-property', 'FontName'), 'FontName', 'Helvetica');
   set(findall(hf(i), '-property', 'LineWidth'), 'LineWidth', 2.5);

   % Expand axis to fill figure 
   hLeg = findobj(hf(i), 'Type', 'Legend');
   if isempty(hLeg)
      LegPos = [0, 0];
   else
      LegPos = hLeg.Position;
   end

   tightInset = get(hx, 'TightInset');
   pos = get(hx, 'Position');

   % Check if a colorbar exists
   hcbar = findobj(hf(i), 'Type', 'colorbar');
   if isempty(hcbar)
      looseInset = [0, 0, 0, 0];
   else
      cbarPos = get(hcbar, 'Position');
      if strcmp(get(hx, 'DataAspectRatioMode'), 'manual')
	 looseInset = [0, 0, 0, 0];
      else
	 looseInset = [0, 0, cbarPos(1)+cbarPos(3)-pos(1)-pos(3), 0.1];
      end
   end

   outerPos = get(hx, 'OuterPosition');

   set(hx,'LooseInset', looseInset);

%   set(hx, 'Position', [tightInset(1), tightInset(2)+LegPos(2), outerPos(1)+outerPos(3)-tightInset(1)-tightInset(3),...
%      outerPos(2)+outerPos(4)-tightInset(2)-tightInset(4)-LegPos(2)]);

   drawnow

   % Keep axis limit
   set(hx, 'XLim', xlim, 'YLim', ylim);

   drawnow
   
end


