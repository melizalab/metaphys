function handle = FindFigure(tag)
%
% FINDFIGURE Finds the figure window with a given tag.  
%
% Usage:  handle = FINDFIGURE(tag)
%
% tag - a string that matches the figure's tag
%
% handle - the matlab GUI handle that identifies the figure. If the figure
%          does not exist, returns []
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

error(nargchk(1,1,nargin))
tag = lower(tag);

handle      = findobj('tag',tag,'type','figure');
if ishandle(handle)
    figure(handle);
else
    handle  = [];
end