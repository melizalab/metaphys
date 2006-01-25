function out = GetSweepCounter()
%
% GETSWEEPCOUNTER Returns the current number of sweeps acquired
%
% out = GETSWEEPCOUNTER
%
% If the sweepcounter has not been properly initialized, returns 0
%
% $Id: GetSweepCounter.m,v 1.1 2006/01/25 17:49:24 meliza Exp $

FIELDNAME   = 'sweepcounter';

out         = GetGlobal(FIELDNAME);
if isempty(out)
    out     = 0;
end
