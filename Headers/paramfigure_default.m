function props = paramfigure_default()
%
% PARAMFIGURE_DEFAULT Returns default properties for new figures.
%
% $Id: paramfigure_default.m,v 1.1 2006/01/10 20:59:51 meliza Exp $

props = struct('numbertitle','off',...
               'DoubleBuffer','off',...
               'menubar','none',...
               'Color',get(0,'defaultUicontrolBackgroundColor'));
