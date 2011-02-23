function fig = OpenFigure(module,varargin)
% OPENFIGURE Opens a blank figure window, or if a figure with that handle 
% already exists, returns the handle to it.  
%
% The initialized figure is then added to the control structure. The user
% can specify property values in additional optional arguments as follows:
%
% Usage: handle =  OPENFIGURE(module,[prop1,val1],[prop2,val2],[...])
%
% module - the name of the module 
% propn  - property name
% valn   - the corresponding value
%
% See also: OPENGUIDEFIGURE, INITMODULE
% 
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

% open or find the figure
module  = lower(module);
fig     = figure();

% set figure properties
SetObjectDefaults(fig, 'figure')
if nargin > 2
    set(fig, varargin{:});
end

InitModule(module, fig);
