function [] = AddChannel(instrument, channelname, channel)
%
% ADDCHANNEL Adds a channel to the instrument structure.
%
% ADDCHANNEL(instrument, channelname, channel) - Adds the channel <channel>
% to the instrument <instrument> under the name <channelname>. If a channel
% exists with that name, it will be deleted and overwritten with the new
% channel.
%
% See Also: CHANNEL_STRUCT
%
% $Id: AddChannel.m,v 1.3 2006/01/12 02:02:02 meliza Exp $

global mpctrl
PROTECTED_NAMES = {'input','output','all'};

if ~isvalid(channel)
    error('METAPHYS:channel:invalidObject','The channel object is invalid.')
end

%% Check channel name
if any(strmatch(lower(channelname),PROTECTED_NAMES,'exact'))
    delete(channel)
    error('METAPHYS:channel:invalidName',...
        'The channel name %s is invalid.', channelname)
end

%% Look up instrument
instr   = GetInstrument(instrument);

%% Delete existing channel object
if isfield(instr, channelname)
    if isvalid(instr.(channelname).obj)
        delete(instr.(channelname).obj)
    end
end

%% Get parent's name
parent  = channel.Parent;
%% Determine channel type
switch lower(parent.Type)
    case 'analog input'
        type    = 'output';
    case 'analog output'
        type    = 'input';
    otherwise
        error('METAPHYS:invalidChannelType',...
        'The channel type %s cannot be added to instruments.', channel.Type)
end

chan_struct = struct('obj', channel,...
                     'name', channelname,...
                     'daq', parent.Name,...
                     'type', type);
                     

mpctrl.instrument.(instrument).channels.(channelname)    = chan_struct;

DebugPrint('Added channel %s to instrument %s.', channelname, instrument);