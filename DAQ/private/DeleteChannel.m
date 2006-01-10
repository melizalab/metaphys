function [] = DeleteChannel(instrument, channelname)
%
% DELETECHANNEL Deletes a channel from the control structure
%
% If the channel does not exist, a warning is thrown.
%
% $Id: DeleteChannel.m,v 1.1 2006/01/11 03:20:00 meliza Exp $

global mpctrl

instr   = GetInstrument(instrument);
if isfield(instr, channelname)
    channames   = fieldnames(instr);
    chanindex   = strmatch(channelname, channames);
    chan        = instr.(channelname);
    chantype    = GetChannelType(chan);
    nodel       = setdiff(1:length(channames), chanindex);
    if strcmpi(chantype, 'Analog Input')
        delete(chan)
    end
    z       = instr.channels(nodel);
    mpctrl.instrument.(instrument).channels = z;
else
    warning('METAPHYS:deleteChannel:noSuchChannel',...
        'The channel %s has not been defined for instrument %s',...
        channelname, instrument)
end