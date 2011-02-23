function [] = IncrementSweepCounter()
%
% INCREMENTSWEEPCOUNTER Increases the value of the sweep counter
%
% See also: GETSWEEPCOUNTER, RESETSWEEPCOUNTER
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE
%

FIELDNAME   = 'sweepcounter';
sweeps  = GetSweepCounter;
SetGlobal(FIELDNAME, sweeps + 1)