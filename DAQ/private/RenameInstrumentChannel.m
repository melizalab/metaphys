function [] = RenameInstrumentChannel(instrument, channelname, newname)
%
% RENAMEINSTRUMENTCHANNEL Renames a channel in the instrument structure
%
% This is nontrivial, since the name of the channel is stored in the
% channel object itself, and is the fieldname of the object, so there is
% some mpctrl tinkering.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

global mpctrl

chan    = GetChannelStruct(instrument, channelname);

switch lower(chan.type)
    case 'channel'
        set(chan.obj, 'ChannelName', newname)
    case 'line'
        set(chan.obj, 'LineName', newname)
end

chan.name   = newname;

mpctrl.instrument.(instrument).channels = ...
    rmfield(mpctrl.instrument.(instrument).channels,channelname);

mpctrl.instrument.(instrument).channels.(newname) = chan;

DebugPrint('Renamed channel %s to %s.', channelname, newname)