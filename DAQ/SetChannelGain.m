function [] = SetChannelGain(varargin)
%
% SETCHANNELGAIN Sets the gain of a channel
%
% The gain of a channel is defined as the ratio between the units reported
% by the DAQ toolkit (or sent to the toolkit, in the case of aochannels)
% and the actual voltage produced by the line. Generally one wants the gain
% on the instrument to match the gain in the software, so that if your
% AxoClamp 200B outputs 1 V for every 20 mV, then this software will report
% 20 mV for every V it sees. Note, therefore, that the gain argument used
% here is CHANNEL gain; i.e. the inverse of INSTRUMENT gain. 
%
% SETCHANNELGAIN(instrument, channelname, gain)
% SETCHANNELGAIN(channelobj, gain)
%
% See also: GETCHANNELGAIN
%
% $Id: SetChannelGain.m,v 1.5 2006/01/31 22:48:20 meliza Exp $

if ischar(varargin{1})
    chanstr     = GetChannelStruct(varargin{1}, varargin{2});
    channel     = chanstr.obj;
    chantype    = chanstr.type;
    gain        = varargin{3};
    parent      = chanstr.daq;
else
    channel     = varargin{1};
    chantype    = GetChannelType(channel);
    gain        = varargin{2};
    parent      = get(channel.Parent,'Name');
end

switch lower(chantype)
    case 'output'
        sensor  = get(channel,'SensorRange');
        output  = sensor .* gain;
    case 'input'
        voltage = get(channel,'OutputRange');
        output  = voltage .* gain;
    otherwise
        error('METAPHYS:invalidOperation',...
            'Gain cannot be set on objects of type %s', chantype)
end

set(channel,'UnitsRange', output)
% defaultchannelvalue no longer applies so we have to call resetdaqoutput
if strcmpi(chantype, 'input')
    ResetDAQOutput(parent)
end