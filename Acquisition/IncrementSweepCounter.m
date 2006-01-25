function [] = IncrementSweepCounter()
%
% INCREMENTSWEEPCOUNTER Increases the value of the sweep counter
%
% $Id: IncrementSweepCounter.m,v 1.1 2006/01/25 17:49:24 meliza Exp $
%

FIELDNAME   = 'sweepcounter';
sweeps  = GetSweepCounter;
SetGlobal(FIELDNAME, sweeps + 1)