function gain = GetChannelGain(varargin)
%
% GETCHANNELGAIN Returns the gain setting on a channel
%
% GETCHANNELGAIN(instrument, channelname) - from a named channel
% GETCHANNELGAIN(channelobj) - from a channel object
% GETCHANNELGAIN(chaninfostruct) - from a channel info struct; assumes that
%                                  the channel is an analog input child
%
% This method is not equipped to deal with nonsymmetric input/output
% ranges. Also note that the values returned are CHANNEL gains (Units/V),
% not instrument gains.
% 
% See Also: SETCHANNELGAIN
%
% $Id: GetChannelGain.m,v 1.3 2006/01/31 22:48:18 meliza Exp $

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

switch lower(chantype)
    case 'output'
        gain    = channel.UnitsRange ./ channel.SensorRange;
        gain    = gain(1);
    case 'input'
        gain    = channel.UnitsRange ./ channel.OutputRange;
        gain    = gain(1);
    otherwise
        error('METAPHYS:channel:invalidOperation',...
            'Channel type %s does not have a gain setting.', chantype)
end
