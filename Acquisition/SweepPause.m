function [] = SweepPause(time)
%
% SWEEPPAUSE Pauses between sweeps for a fixed number of milliseconds
%
% Like PAUSE, SWEEPPAUSE suspects program execution for a fixed amount of
% time. Unlike PAUSE, it notifies the rest of the system by setting a
% global variable which can be checked by other threads that would like to
% stop acquisition.
%
% $Id: SweepPause.m,v 1.1 2006/01/25 22:22:45 meliza Exp $

SetGlobal('sweep_pause',true)
pause(time/1000);
SetGlobal('sweep_pause',false)
