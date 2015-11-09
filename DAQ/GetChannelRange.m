function vrange = GetChannelRange(varargin)
%
% GETCHANNELRANGE Returns the voltage range of a channel
%
% GETCHANNELRANGE(instrument, channelname) - from a named channel
% GETCHANNELRANGE(channelobj) - from a channel object
% GETCHANNELRANGE(chaninfostruct) - from a channel info struct; assumes that
%                                  the channel is an analog input child
%
% The voltage range of a channel is the range of voltages that the
% instrument produces (for output channels) or processes (for input
% channels).  Generally one wants this to be as close as possible to the
% actual voltage range of the instrument to maximize resolution.  Note that
% range is a two-element vector.
% 
% See Also: SETCHANNELRANGE
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

switch lower(chantype)
    case 'output'
        vrange = channel.InputRange;
    case 'input'
        vrange = channel.OutputRange;
    otherwise
        error('METAPHYS:channel:invalidOperation',...
            'Channel type %s does not have a gain setting.', chantype)
end
