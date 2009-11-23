function [] = stopmovie(obj)
%
% STOPMOVIE Stops movie playback
%
% STOPMOVIE(f21control)
%
% OUTPUTS: none
%
% $Id: stopmovie.m,v 1.1 2006/01/24 03:26:10 meliza Exp $

sendcommand(obj, 'break');
% no output expected