function [] = AddChannel(instrument, channelname, channel)
%
% ADDCHANNEL Adds a channel to the instrument structure.
%
% ADDCHANNEL(instrument, channelname, channel) - Adds the channel <channel>
% to the instrument <instrument> under the name <channelname>. If a channel
% exists with that name, it will be deleted and overwritten with the new
% channel.
%
% $Id: AddChannel.m,v 1.2 2006/01/11 23:04:00 meliza Exp $

global mpctrl

instr   = GetInstrument(instrument);

if isfield(instr, channelname)
    if isvalid(instr.(channelname))
        delete(instr.(channelname))
    end
end

mpctrl.instrument.(instrument).channels.(channelname)    = channel;

DebugPrint('Added channel %s to instrument %s.', channelname, instrument);