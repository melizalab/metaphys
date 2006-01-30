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
% $Id: StopDAQ.m,v 1.4 2006/01/30 20:04:44 meliza Exp $


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

