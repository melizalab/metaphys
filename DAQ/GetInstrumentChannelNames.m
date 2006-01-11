function [channames pretty]  = GetInstrumentChannelNames(instrument, type)
%
% GETINSTRUMENTCHANNELNAMES Returns a cell array containing a list of all
% the defined instrument channels for a given instrument.
%
% [names, pretty] = GETINSTRUMENTCHANNELNAMES(instrumentname,[type])
%
% Type can be 'all' (default), 'input', or 'output'
%
% <names> is a simple cell array containing the list of channel names
% <pretty> is a cell array with "prettified" output: <id>:<name> (<units>)
%
% See Also: GETINSTRUMENTNAMES, INITINSTRUMENT
%
% $Id: GetInstrumentChannelNames.m,v 1.3 2006/01/11 23:03:56 meliza Exp $

pretty  = [];
if nargin == 1
    type    = 'all';
end

% Retrieve instrument channels and types
[channels channames]  = GetInstrumentChannel(instrument);

if isempty(channels)
    return
end

chantypes   = GetChannelType(channels);

% Figure out which channels are which. Note the tricky input/output
% relationship between instrument and daq channels.
switch lower(type)
    case 'all'
        ind     = 1:length(channels);
    case 'input'
        ind     = strmatch('Analog Output',chantypes);
    case 'output'
        ind     = strmatch('Analog Input', chantypes);
    otherwise
        error('METAPHYS:noSuchChannelType',...
            'No such channel type %s has been defined.',...
            type)
end
channames   = CellWrap(channames(ind));

if nargout > 1
    index   = find(ind);
    for i = 1:length(index)
        p         = channels(index(i)).Parent;
        pretty{i} = sprintf('%d: %s (%s) [%s/%d]', channels(index(i)).Index,...
            channames{index(i)}, channels(index(i)).Units,...
            p.Name, channels(index(i)).HwChannel);
    end
end