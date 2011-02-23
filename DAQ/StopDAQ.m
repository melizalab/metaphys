function [] = StopDAQ(daqnames)
%
% STOPDAQ Stops one or more DAQs from running.
%
% STOPDAQ(daqnames) stops a single or multiple daqs (if daqnames is a cell
%                   array)
%
% STOPDAQ stops all daqs in the control structure
%
% See also: INITDAQ, RESETDAQ, STARTDAQ
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE


if nargin == 0
    daqnames   = GetDAQNames;
    if isempty(daqnames)
        return
    end
end

daqs    = GetDAQ(daqnames);
stop(daqs(isvalid(daqs)));

MatWriter('flush');
EnableSensitiveControls('on');

