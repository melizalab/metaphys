function gain = GetChannelGain(varargin)
%
% GETCHANNELGAIN Returns the gain setting on a channel
%
% GETCHANNELGAIN(instrument, channelname) - from a named channel
% GETCHANNELGAIN(channelobj) - from a channel object
% GETCHANNELGAIN(chaninfostruct) - from a channel info struct; assumes that
%                                  the channel is an analog input child
%
% Note that the values returned are CHANNEL gains (Units/V),
% not instrument gains.
% 
% See Also: SETCHANNELGAIN
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if ischar(varargin{1})
    chanstr     = GetChannelStruct(varargin{1}, varargin{2});
    channel     = chanstr.obj;
    chantype    = chanstr.type;
elseif isa(varargin{1}, 'daqchild')
    channel     = varargin{1};
    chantype    = GetChannelType(channel);
else
    channel     = varargin{1};
    chantype    = 'output';
end

unitrange = diff(channel.UnitsRange);
switch lower(chantype)
    case 'output'
        voltrange = diff(channel.SensorRange);
    case 'input'
        voltrange = diff(channel.OutputRange);
    otherwise
        error('METAPHYS:channel:invalidOperation',...
            'Channel type %s does not have a gain setting.', chantype)
end
gain = unitrange / voltrange;