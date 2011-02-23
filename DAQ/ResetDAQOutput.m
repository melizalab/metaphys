function [] = ResetDAQOutput(daq, event)
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
% * Even worse, sometimes behavior (3) fails to happen, which is a serious
% problem if this feature is being used to hold a command voltage.
% Therefore, this function should be called whenever an analog output
% device is stopped. It has the correct function signature to be used as a
% callback for the StopFcn on an analogout device.
%
% Safe for analoginput and digitialio objects.
%
% RESETDAQOUTPUT(daqname) - resets the daq outputs on named daqdevice(s)
% RESETDAQOUTPUT(obj, event) - resets the callback object
% RESETDAQOUTPUT()        - resets the outputs on all output devices
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if nargin == 0
    daqname = GetDAQNames('analogoutput');
    daq     = GetDAQ(daqname);
elseif ischar(daq)
    daq     = GetDAQ(daq);
end

for i = 1:size(daq,2)
    if strcmp('Analog Output', daq.Type)
        defaults    = GetDefaultValues(daq);
        if ~isempty(defaults)
            putsample(daq, defaults)
        end
    end
end
