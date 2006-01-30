function [channames pretty short]  = GetInstrumentChannelNames(instrument, type)
%
% GETINSTRUMENTCHANNELNAMES Returns a cell array containing a list of all
% the defined instrument channels for a given instrument.
%
% [names, pretty, short] = GETINSTRUMENTCHANNELNAMES(instrumentname,[type])
%
% Type can be 'all' (default), 'input', or 'output'
%
% <names> is a simple cell array containing the list of channel names
% <pretty> is a cell array with "prettified" output: 
%       <name> (<units>) [<daqname>/<hwchan>]
% <short> is also prettified, but shorter:
%       <name> (<units>)
%
% Names are sorted according to their indices
%
% See also: GETINSTRUMENTNAMES, INITINSTRUMENT
%
% $Id: GetInstrumentChannelNames.m,v 1.6 2006/01/30 20:04:40 meliza Exp $

pretty      = [];
short       = [];
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
    SHORT_FORMAT    = '%s (%s)';
    PRETTY_FORMAT   = '%s (%s) [%s/%d]';
    daqnames        = {channels.daq};
    for i = 1:length(ind)
        pretty{i} = sprintf(PRETTY_FORMAT,...
            channels(i).name,...
            channels(i).obj.Units,...
            daqnames{i},...
            channels(i).obj.HwChannel);
        short{i} = sprintf(SHORT_FORMAT,...
            channels(i).name,...
            channels(i).obj.Units);
    end
end