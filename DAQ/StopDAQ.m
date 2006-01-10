function [] = StopDAQ(daqnames)
%
% STOPDAQ Stops one or more DAQs from running.
%
% STOPDAQ(daqnames) stops a single or multiple daqs (if daqnames is a cell
%                   array)
%
% STOPDAQ stops all daqs in the control structure
%
% See Also: INITDAQ, RESETDAQ, STARTDAQ
%
% $Id: StopDAQ.m,v 1.1 2006/01/10 20:59:50 meliza Exp $


if nargin == 0
    daqnames   = GetDAQNames;
    if isempty(daqnames)
        return
    end
end

daqs    = GetDAQ(daqnames);
stop(daqs(isvalid(daqs)));
