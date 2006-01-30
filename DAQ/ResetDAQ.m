function [] = ResetDAQ(varargin)
%
% RESETDAQ Returns a daq device to its initial state. 
%
% The device is stopped, and the initial properties (stored when the device
% was initialized) re-applied.
%
% RESETDAQ(daqnames) resets a single or multiple daqs
%
% RESETDAQ resets all daqs in the control structure
%
% See also: INITDAQ, STOPDAQ
%
% $Id: ResetDAQ.m,v 1.3 2006/01/30 20:04:42 meliza Exp $

if nargin == 0
    daqnames = GetDAQNames;
else
    daqnames = varargin;
end

if isempty(daqnames)
    DebugPrint('No DAQ devices have been initialized.')
else
    StopDAQ(daqnames)
    daqstr      = GetDAQStruct(daqnames);

    for i = 1:length(daqstr)
        set(daqstr(i).obj, daqstr(i).initial_props);
        DebugPrint('Reset DAQ device %s.', daqstr(i).obj.Name)
    end
end
