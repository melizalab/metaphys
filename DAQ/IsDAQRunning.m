function out   = IsDAQRunning()
%
% ISDAQRUNNING Returns true if any daq is currently running
%
% out = ISDAQRUNNING
%
% $Id: IsDAQRunning.m,v 1.1 2006/01/25 22:22:46 meliza Exp $

daqnames   = GetDAQNames;
if isempty(daqnames)
    out    = false;
else
    daqs    = GetDAQ(daqnames);
    running = get(daqs,'Running');
    if any(strncmpi('On',running,2))
        out = true;
    else
        out = false;
    end
end

out = out || IsSweepPaused;