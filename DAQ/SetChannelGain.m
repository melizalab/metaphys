function [] = SetChannelGain(varargin)
%
% SETCHANNELGAIN Sets the gain of a channel
%
% The gain of a channel is defined as the ratio between the units reported
% by the DAQ toolkit (or sent to the toolkit, in the case of aochannels)
% and the actual voltage produced by the line. Generally one wants the gain
% on the instrument to match the gain in the software, so that if your
% AxoClamp 200B outputs 1 V for every 20 mV, then this software will report
% 20 mV for every V it sees.
%
% SETCHANNELGAIN(instrument, channelname, gain)
% SETCHANNELGAIN(channelobj, gain)
%
% See Also: GETCHANNELGAIN
%
% $Id: SetChannelGain.m,v 1.1 2006/01/11 23:03:58 meliza Exp $

if ischar(varargin{1})
    channel     = GetInstrumentChannel(varargin{1}, varargin{2});
    gain        = varargin{3};
else
    channel     = varargin{1};
    gain        = varargin{2};
end

chantype    = GetChannelType(channel);
switch lower(chantype)
    case 'analog input'
        sensor  = get(channel,'SensorRange');
        output  = sensor .* gain;
    case 'analog output'
        voltage = get(channel,'OutputRange');
        output  = voltage .* gain;
    otherwise
        error('METAPHYS:invalidOperation',...
            'Gain cannot be set on objects of type %s', chantype)
end

set(channel,'UnitsRange', output)