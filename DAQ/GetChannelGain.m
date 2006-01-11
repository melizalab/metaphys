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
% $Id: GetChannelGain.m,v 1.2 2006/01/12 02:02:01 meliza Exp $

if ischar(varargin{1})
    chanstr     = GetChannelStruct(varargin{1}, varargin{2});
    channel     = chanstr.obj;
    chantype    = chanstr.type;
else
    channel     = varargin{1};
    chantype     = GetChannelType(channel);
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
