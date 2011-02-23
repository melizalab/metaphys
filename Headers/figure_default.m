function props = figure_default()
%
% FIGURE_DEFAULT Returns default properties for new figures.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

props = struct('numbertitle','off',...
               'DoubleBuffer','on',...
               'menubar','none',...
               'Color',get(0,'defaultUicontrolBackgroundColor'));
