function out = GetSweepCounter()
%
% GETSWEEPCOUNTER Returns the current number of sweeps acquired
%
% out = GETSWEEPCOUNTER
%
% If the sweepcounter has not been properly initialized, returns 0
%
% See also: INCREMENTSWEEPCOUNTER, RESETSWEEPCOUNTER
%
% $Id: GetSweepCounter.m,v 1.2 2006/01/30 20:04:34 meliza Exp $

FIELDNAME   = 'sweepcounter';

out         = GetGlobal(FIELDNAME);
if isempty(out)
    out     = 0;
end
