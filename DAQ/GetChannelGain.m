function gain = GetChannelGain(varargin)
%
% GETCHANNELGAIN Returns the gain setting on a channel
%
% GETCHANNELGAIN(instrument, channelname) - from a named channel
% GETCHANNELGAIN(channelobj) - from a channel object
%
% This method is not equipped to deal with nonsymmetric input/output ranges
% 
% See Also: SETCHANNELGAIN
%
% $Id: GetChannelGain.m,v 1.1 2006/01/11 23:03:56 meliza Exp $

if ischar(varargin{1})
    channel     = GetInstrumentChannel(varargin{1}, varargin{2});
else
    channel     = varargin{1};
end
chantype    = GetChannelType(channel);
switch lower(chantype)
    case 'analog input'
        gain    = channel.UnitsRange ./ channel.SensorRange;
        gain    = gain(1);
    case 'analog output'
        gain    = channel.UnitsRange ./ channel.OutputRange;
        gain    = gain(1);
    otherwise
        error('METAPHYS:invalidOperation',...
            'Channel type %s does not have a gain setting.', chantype)
end
