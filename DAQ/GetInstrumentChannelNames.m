function channames   = GetInstrumentChannelNames(instrument, type)
%
% GETINSTRUMENTCHANNELNAMES Returns a cell array containing a list of all
% the defined instrument channels for a given instrument.
%
% GETINSTRUMENTCHANNELNAMES(instrumentname,[type])
%
% Type can be 'all' (default), 'input', or 'output'
%
% See Also: GETINSTRUMENTNAMES, INITINSTRUMENT
%
% $Id: GetInstrumentChannelNames.m,v 1.2 2006/01/11 03:19:57 meliza Exp $

if nargin == 1
    type    = 'all';
end

% Retrieve instrument channels and types
instr       = GetInstrument(instrument);
if isstruct(instr.channels)
    channames   = fieldnames(instr.channels);
    chantypes   = GetChannelType(instr.channels);
else
    channames   = [];
end

if ~isempty(channames)
    % Figure out which channels are which. Note the tricky input/output
    % relationship between instrument and daq channels.
    switch lower(type)
        case 'all'
            ind     = 1:length(chantypes);
        case 'input'
            ind     = strmatch('Analog Output',chantypes);
        case 'output'
            ind     = strmatch('Analog Input', chantypes);
        otherwise
            error('METAPHYS:noSuchChannelType',...
                'No such channel type %s has been defined.',...
                type)
    end
    channames   = channames{ind};
end