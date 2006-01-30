function [] = IncrementSweepCounter()
%
% INCREMENTSWEEPCOUNTER Increases the value of the sweep counter
%
% See also: GETSWEEPCOUNTER, RESETSWEEPCOUNTER
%
% $Id: IncrementSweepCounter.m,v 1.2 2006/01/30 20:04:34 meliza Exp $
%

FIELDNAME   = 'sweepcounter';
sweeps  = GetSweepCounter;
SetGlobal(FIELDNAME, sweeps + 1)