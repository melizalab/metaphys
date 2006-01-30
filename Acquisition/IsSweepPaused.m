function out = IsSweepPaused()
%
% ISSWEEPPAUSED Returns true if the acquisition is currently paused between
% sweeps.
%
% See also: SWEEPPAUSE, ISDAQRUNNING
%
% $Id: IsSweepPaused.m,v 1.2 2006/01/30 20:04:35 meliza Exp $

out = GetGlobal('sweep_pause');
if isempty(out)
    out = false;
end
