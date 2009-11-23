function [] = display(obj)
%
% DISPLAY Display method for waveformevent
%
% $Id: display.m,v 1.1 2006/01/26 01:21:32 meliza Exp $

disp(' ');
disp([inputname(1),' = '])
disp(' ');
disp(struct(obj))
disp(' ');