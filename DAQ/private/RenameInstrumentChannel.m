function [] = RenameInstrumentChannel(instrument, channelname, newname)
%
% RENAMEINSTRUMENTCHANNEL Renames a channel in the instrument structure
%
% This is nontrivial, since the name of the channel is stored in the
% channel object itself, and is the fieldname of the object, so there is
% some mpctrl tinkering.
%
% $Id: RenameInstrumentChannel.m,v 1.1 2006/01/11 23:04:01 meliza Exp $

global mpctrl

chan    = GetInstrumentChannel(instrument, channelname);
type    = get(chan,'Type')

switch lower(type)
    case 'channel'
        set(chan, 'ChannelName', newname)
    case 'line'
        set(chan, 'LineName', newname)
end
            

mpctrl.instrument.(instrument).channels = rmfield(mpctrl.instrument.(instrument).channels,...
                                                  channelname);
mpctrl.instrument.(instrument).channels.(newname) = chan;                                              