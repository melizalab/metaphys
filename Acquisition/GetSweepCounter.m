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
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

FIELDNAME   = 'sweepcounter';

out         = GetGlobal(FIELDNAME);
if isempty(out)
    out     = 0;
end
