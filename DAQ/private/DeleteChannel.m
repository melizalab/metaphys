function [] = DeleteChannel(instrument, channelname)
%
% DELETECHANNEL Deletes a channel from the control structure
%
% If the channel does not exist, a warning is thrown.
%
% $Id: DeleteChannel.m,v 1.2 2006/01/11 23:04:00 meliza Exp $

global mpctrl

instr   = GetInstrument(instrument);
if isfield(instr.channels, channelname)
    chan        = instr.channels.(channelname);
    chantype    = GetChannelType(chan);
    if strcmpi(chantype, 'Analog Input')
        delete(chan)
    end
    mpctrl.instrument.(instrument).channels = ...
        rmfield(mpctrl.instrument.(instrument).channels, channelname);
    DebugPrint('Deleted channel %s from instrument %s.', channelname,...
        instrument);
else
    warning('METAPHYS:deleteChannel:noSuchChannel',...
        'The channel %s has not been defined for instrument %s',...
        channelname, instrument)
end