function [] = startmovie(obj)
%
% STARTMOVIE Starts movie playback
%
% STARTMOVIE(f21ctrl)
%
% OUTPUTS: none
%
% $Id: startmovie.m,v 1.1 2006/01/24 03:26:09 meliza Exp $

sendcommand(obj, 'start');
% no output expected