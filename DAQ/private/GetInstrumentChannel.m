function chan   = GetInstrumentChannel(instrument, channel)
%
% GETINSTRUMENTCHANNEL Returns the channel object associated with an
% instrument channel. 
%
% If the instrument or channel have not been defined, an error is thrown.
%
% chan = GETINSTRUMENTCHANNEL(instrument, channel)
%
% CHANNEL can be a cell array, in which case multiple channels will be
% retrieved as an array of objects.
%
% $Id: GetInstrumentChannel.m,v 1.2 2006/01/11 03:20:01 meliza Exp $

instr   = GetInstrument(instrument);

if iscell(channel)
    for i = 1:length(channel)
        chan(i) = getchannel(instr, channel{i});
    end
else
    chan    = getchannel(instr, channel);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function chan = getchannel(mpstruct, channel)

if ~isfield(mpstruct, channel)
    error('METAPHYS:daq:noSuchChannel',...
        'No such channel %s has been defined.',...
        channel)
end 

chan = mpstruct.(channel);