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
% See Also: OPENGUIDEFIGURE, INITMODULE
% 
% $Id: OpenFigure.m,v 1.1 2006/01/10 20:59:53 meliza Exp $

% open or find the figure
module  = lower(module);
fig     = figure();

% set figure properties
SetObjectDefaults(fig, 'figure')
if nargin > 2
    set(fig, varargin{:});
end

InitModule(module, fig);
