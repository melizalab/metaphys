function [] = ResetDAQOutput(daqname)
%
% RESETDAQOUTPUT Returns the output values of a DAQ analogoutput to their
% default values.
%
% Even when a DAQ device is not running, its analog outputs will be
% outputting some voltage. This voltage is determined by several variables:
% (1) the setting of the 'OutOfDataMode' property, (2) the last value sent
% to the DAQ, and (3) the value of the 'DefaultChannelValue' property of
% each channel.  If 'OutOfDataMode' is set to 'DefaultValue', then when the
% device stops it should return to the channel default value; if it is set
% to 'Hold' it will remain at the last value sent to the daq.
%
% Unfortunately, this behavior becomes irregular when the
% 'DefaultChannelValue' property is directly modified, since this does not
% cause the DAQ to change the output voltage. Therefore, if these values
% are ever changed, this function should be called immediately afterward if
% the actual holding voltage needs to change.
%
% RESETDAQOUTPUT(daqname) - resets the daq outputs on named daqdevice(s)
%
% RESETDAQOUTPUT()        - resets the outputs on all output devices
%
% $Id: ResetDAQOutput.m,v 1.1 2006/01/17 20:22:09 meliza Exp $

if nargin == 0
    daqname = GetDAQNames('analogoutput');
else
    daqname = CellWrap(daqname);
end

for i = 1:length(daqname)
    setdaqtodefault(daqname{i})
end

function [] = setdaqtodefault(name)
daq     = GetDAQ(name);
if strcmpi(daq.Type, 'analog output')
    if strcmpi(daq.Running, 'Off')
        defaults    = get(daq.Channel, 'DefaultChannelValue')';
        if iscell(defaults)
            defaults    = cell2mat(defaults);
        end
        putsample(daq, defaults);
    else
        warning('METAPHYS:resetdaqoutput:deviceRunning',...
            'ResetDAQOutput should only be called on stopped devices.')
    end
else
    warning('METAPHYS:resetdaqoutput:',...
        '%s is not an analog output device.', name)
end
        