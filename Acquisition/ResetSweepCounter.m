function [] = ResetSweepCounter()
%
% RESETSWEEPCOUNTER Resets the global sweep counter
%
% The global sweep counter is incremented every time STARTDAQ is called. It
% needs to be reset at the beginning of an experiment in order for it to
% match the number of sweeps that have been collected.
%
% $Id: ResetSweepCounter.m,v 1.1 2006/01/25 17:49:24 meliza Exp $

FIELDNAME   = 'sweepcounter';
SetGlobal(FIELDNAME, 0);
