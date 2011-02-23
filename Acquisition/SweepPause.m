function [] = SweepPause(time)
%
% SWEEPPAUSE Pauses between sweeps for a fixed number of milliseconds
%
% Like PAUSE, SWEEPPAUSE suspects program execution for a fixed amount of
% time. Unlike PAUSE, it notifies the rest of the system by setting a
% global variable which can be checked by other threads that would like to
% stop acquisition.
%
% See also: ISSWEEPPAUSED, ISDAQRUNNING
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

SetGlobal('sweep_pause',true)
pause(time/1000);
SetGlobal('sweep_pause',false)
