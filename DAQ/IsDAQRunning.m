function out   = IsDAQRunning()
%
% ISDAQRUNNING Returns true if any daq is currently running
%
% out = ISDAQRUNNING
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

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