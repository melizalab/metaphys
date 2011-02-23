function [] = ResetSweepCounter()
%
% RESETSWEEPCOUNTER Resets the global sweep counter
%
% The global sweep counter is incremented every time STARTDAQ is called. It
% needs to be reset at the beginning of an experiment in order for it to
% match the number of sweeps that have been collected.
%
% See also: GETSWEEPCOUNTER, INCREMENTSWEEPCOUNTER
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

FIELDNAME   = 'sweepcounter';
SetGlobal(FIELDNAME, 0);
