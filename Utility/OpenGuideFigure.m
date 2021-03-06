function fig = OpenGuideFigure(figfile, module)
%
% OPENGUIDEFIGURE Opens a figure window using a GUIDE-generated .fig
% file. 
%
% The figure handle and the handles of its component (tagged) uicontrols
% will be added to the control structure.
%
% fig   = OPENGUIDEFIGURE(figfile, [module])
%
%   figfile - the name of the figure to be opened. if no full path is
%   given, the path will be searched (see OPENFIG)
%
%   module - if this is not supplied, the figure's name will be used as its
%   tag and module name. if it is supplied, the figure will be renamed,
%   retagged, and added into the control structure under that name
%
%   FINDFIGURE is used to detect if the module figure has already been
%   opened. In this case the handles will be re-stored in the control
%   structure.
%
%  See also: OPENFIGURE, FINDFIGURE
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if nargin == 1
    [pn fn] = fileparts(figfile);
    tag = lower(fn);
else
    tag = lower(module);
end

% check for existing figure; if none, open
DebugPrint('Opening GUIDE figure for module %s.', tag);
fig     = FindFigure(tag);
if isempty(fig)
   fig  = openfig(figfile);
end

InitModule(tag, fig);
