function [] = SetChannelRange(varargin)
%
% SETCHANNELRANGE Sets the range of a channel
%
% The range of a channel is a two-element vector that specifies the
% voltages the channel will stay between.  If the signal is outside this
% range the DAQ will clip, so the range needs to be large enough to
% encompass any reasonable signals.  On the other end, the smaller the
% range, the more resolution the DAQ will have.
%
% Changing the channel range does not update the corresponding units range,
% so the gain WILL change.  Call SETCHANNELGAIN after SETCHANNELRANGE.
% Also note that most DAQ boards only support a fixed set of ranges, and
% will adjust invalid values to the closest valid range.
%
% SETCHANNELRANGE(instrument, channelname, range)
% SETCHANNELRANGE(channelobj, range)
%
% See also: GETCHANNELRANGE
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if ischar(varargin{1})
    chanstr     = GetChannelStruct(varargin{1}, varargin{2});
    channel     = chanstr.obj;
    chantype    = chanstr.type;
    range       = varargin{3};
    parent      = chanstr.daq;
else
    channel     = varargin{1};
    chantype    = GetChannelType(channel);
    range       = varargin{2};
    parent      = get(channel.Parent,'Name');
end

switch lower(chantype)
    case 'output'
        set(channel,'InputRange',range);
        % need to use actual InputRange value
        set(channel,'SensorRange',get(channel,'InputRange'));
    case 'input'
        set(channel,'OutputRange',range);
    otherwise
        error('METAPHYS:invalidOperation',...
            'Gain cannot be set on objects of type %s', chantype)
end

% defaultchannelvalue no longer applies so we have to call resetdaqoutput
if strcmpi(chantype, 'input')
    ResetDAQOutput(parent)
end