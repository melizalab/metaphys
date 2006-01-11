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
% <pretty> is a cell array with "prettified" output: 
%       <id>:<name> (<units>) [<daqname>/<hwchan>]
%
% Names are sorted according to their indices
%
% See Also: GETINSTRUMENTNAMES, INITINSTRUMENT
%
% $Id: GetInstrumentChannelNames.m,v 1.4 2006/01/12 02:02:01 meliza Exp $

pretty      = [];
channames   = [];
if nargin == 1
    type    = 'all';
end

%% Retrieve instrument channels
channels       = GetChannelStruct(instrument);

if isempty(channels)
    return
end

chantypes   = {channels.type};

%% Figure out which channels are which. 
% Note the tricky input/output relationship between instrument and daq
% channels.
switch lower(type)
    case 'all'
        ind     = 1:length(channels);
    case 'input'
        ind     = strmatch('input',chantypes);
    case 'output'
        ind     = strmatch('output', chantypes);
    otherwise
        error('METAPHYS:noSuchChannelType',...
            'No such channel type %s has been defined.',...
            type)
end

channels    = channels(ind);
channames   = {channels.name};


%% Make the pretty output if necessary

if nargout > 1
%    PRETTY_FORMAT   = '%d: %s (%s) [%s/%d]';
    PRETTY_FORMAT   = '%s (%s) [%s/%d]';
    daqnames        = {channels.daq};
    for i = 1:length(ind)
        pretty{i} = sprintf(PRETTY_FORMAT,...            channels(i).obj.Index,...
            channels(i).name,...
            channels(i).obj.Units,...
            daqnames{i},...
            channels(i).obj.HwChannel);
    end
end