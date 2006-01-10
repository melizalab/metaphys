function [] = StartDAQ(daqnames)
%
% STARTDAQ Starts one or more DAQs running.
%
% STARTDAQ(daqname1, [daqname2,...]) starts a single or multiple daqs 
%                                    (if daqnames is a cell array)
%
% STARTDAQ starts all daqs in the control structure
%
% See Also: INITDAQ, RESETDAQ, STARTDAQ
%
% $Id: StartDAQ.m,v 1.1 2006/01/10 20:59:50 meliza Exp $


if nargin == 0
    daqs    = GetDAQ(GetDAQNames);
else
    daqs    = GetDAQ(daqnames);
end

start(daqs);