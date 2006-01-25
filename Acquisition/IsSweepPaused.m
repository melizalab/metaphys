function out = IsSweepPaused()
%
% ISSWEEPPAUSED Returns true if the acquisition is currently paused between
% sweeps.
%
% $Id: IsSweepPaused.m,v 1.1 2006/01/25 22:22:44 meliza Exp $

out = GetGlobal('sweep_pause');
if isempty(out)
    out = false;
end
