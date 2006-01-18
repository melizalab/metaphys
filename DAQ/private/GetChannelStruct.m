function chan   = GetChannelStruct(instrument, cname)
%
% GETCHANNELSTRUCT Returns the channel structure associated with an
% instrument channel. 
%
% If the instrument or channel have not been defined, an error is thrown.
%
% chan = GETCHANNELSTRUCT(instrument, channel)
%
% CHANNEL can be a cell array, in which case multiple channels will be
% retrieved as an array of structures
%
% chan = GETCHANNELSTRUCT(instrument) - returns all channels
%
% See Also: GETINSTRUMENTCHANNEL
%
% $Id: GetChannelStruct.m,v 1.3 2006/01/19 03:15:00 meliza Exp $

%% Check instrument
instr   = GetInstrument(instrument);

%% Retrieve structure
if isstruct(instr.channels)
    if nargin < 2
        cname   = fieldnames(instr.channels);
    end

    if iscell(cname)
        for i = 1:length(cname)
            chan(i)  = getchanstr(instr, cname{i});
        end
    else
        chan     = getchanstr(instr, cname);
    end
else
    chan    = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function chan  = getchanstr(instr, cname)

if ~isfield(instr.channels, cname)
    error('METAPHYS:channel:channelNotFound',...
        'No channel %s defined for instrument %s.',...
        cname, instr.name)
end

chan = instr.channels.(cname);
if ~isvalid(chan.obj)
    warning('METAPHYS:channel:invalidChannel',...
        'The channel object %s is no longer valid.', cname);
    % Delete the channel from instrument so it stops causing problems
    DeleteChannel(instr.name, cname);
end
