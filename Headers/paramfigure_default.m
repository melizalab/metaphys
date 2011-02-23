function props = paramfigure_default()
%
% PARAMFIGURE_DEFAULT Returns default properties for new figures.
%
% See also: PARAMFIGURE
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

props = struct('numbertitle','off',...
               'DoubleBuffer','off',...
               'menubar','none',...
               'Color',get(0,'defaultUicontrolBackgroundColor'));
