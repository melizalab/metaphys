function handle = FindFigure(tag)
%
% FINDFIGURE Finds the figure window with a given tag.  
%
% Usage:  handle = FINDFIGURE(tag)
%
% tag - a string that matches the figure's tag
%
% handle - the matlab GUI handle that identifies the figure. If the figure
%          does not exist, returns -1
%
% $Id: FindFigure.m,v 1.1 2006/01/10 20:59:52 meliza Exp $

error(nargchk(1,1,nargin))

handle      = findobj('tag',tag,'type','figure');
if ishandle(handle)
    figure(handle);
else
    handle  = -1;
end