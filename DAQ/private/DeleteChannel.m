function [] = DeleteChannel(instrument, channelname)
%
% DELETECHANNEL Deletes a channel from the control structure
%
% If the channel does not exist, a warning is thrown.
%
% $Id: DeleteChannel.m,v 1.6 2006/01/17 20:22:11 meliza Exp $

global mpctrl

instr   = GetInstrument(instrument);

if isfield(instr.channels, channelname)
    chan_struct = instr.channels.(channelname);
    if strcmpi(chan_struct.type, 'output')
        if isvalid(chan_struct.obj)
            DebugPrint('Destroying daqchild %s/%s', chan_struct.daq,...
                chan_struct.obj.ChannelName);
            delete(chan_struct.obj)
        end
    end


    mpctrl.instrument.(instrument).channels = ...
        rmfield(mpctrl.instrument.(instrument).channels, channelname);

    % Clear empty structures
    if length(fieldnames(mpctrl.instrument.(instrument).channels)) < 1
        mpctrl.instrument.(instrument).channels = [];
    end
    
    DebugPrint('Deleted channel %s/%s.', instrument, channelname)
else
    warning('METAPHYS:deleteChannel:noSuchChannel',...
        'The channel %s has not been defined for instrument %s',...
        channelname, instrument)
end