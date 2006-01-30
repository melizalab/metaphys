function props = paramfigure_default()
%
% PARAMFIGURE_DEFAULT Returns default properties for new figures.
%
% See also: PARAMFIGURE
%
% $Id: paramfigure_default.m,v 1.2 2006/01/30 20:04:50 meliza Exp $

props = struct('numbertitle','off',...
               'DoubleBuffer','off',...
               'menubar','none',...
               'Color',get(0,'defaultUicontrolBackgroundColor'));
