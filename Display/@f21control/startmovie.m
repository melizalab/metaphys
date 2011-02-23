function [] = startmovie(obj)
%
% STARTMOVIE Starts movie playback
%
% STARTMOVIE(f21ctrl)
%
% OUTPUTS: none
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

sendcommand(obj, 'start');
% no output expected