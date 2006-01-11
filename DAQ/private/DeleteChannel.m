function [] = DeleteChannel(instrument, channelname)
%
% DELETECHANNEL Deletes a channel from the control structure
%
% If the channel does not exist, a warning is thrown.
%
% $Id: DeleteChannel.m,v 1.3 2006/01/12 02:02:03 meliza Exp $

global mpctrl

instr   = GetInstrument(instrument);

if isfield(instr.channels, channelname)
    chan_struct = instr.channels.(channelname);
    if strcmpi(chan_struct.type, 'output')
        delete(chan_struct.obj)
    end

    if length(mpctrl.instrument.(instrument).channels) == 1
        mpctrl.instrument.(instrument).channels = [];
    else
        mpctrl.instrument.(instrument).channels = ...
            rmfield(mpctrl.instrument.(instrument).channels, channelname);
    end
    DebugPrint('Deleted channel %s/ %s.', instrument, channelname)
else
    warning('METAPHYS:deleteChannel:noSuchChannel',...
        'The channel %s has not been defined for instrument %s',...
        channelname, instrument)
end