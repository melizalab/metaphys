function [] = stopmovie(obj)
%
% STOPMOVIE Stops movie playback
%
% STOPMOVIE(f21control)
%
% OUTPUTS: none
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

sendcommand(obj, 'break');
% no output expected