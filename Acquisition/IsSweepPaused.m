function out = IsSweepPaused()
%
% ISSWEEPPAUSED Returns true if the acquisition is currently paused between
% sweeps.
%
% See also: SWEEPPAUSE, ISDAQRUNNING
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

out = GetGlobal('sweep_pause');
if isempty(out)
    out = false;
end
