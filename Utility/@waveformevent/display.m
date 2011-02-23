function [] = display(obj)
%
% DISPLAY Display method for waveformevent
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

disp(' ');
disp([inputname(1),' = '])
disp(' ');
disp(struct(obj))
disp(' ');