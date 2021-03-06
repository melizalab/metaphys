function [indices, names] = GetChannelIndices(instrument, daqname)
%
% GETCHANNELINDICES Returns the (DAQ) channel indices for all the channels
% on an instrument.
%
% This function is used to convert between instrument-based channels and
% daq-based channels.
%
% [indices, names] = GETCHANNELINDICES(instrument, daqname)
% 
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

instr   = GetInstrument(instrument);
channels   = StructFlatten(instr.channels);

% select which channels to return
dn      = {channels.daq};
ind     = strmatch(daqname, dn, 'exact');

% we don't have to loop since the daqdevice is the same
channels    = [channels(ind).obj];
indices     = get(channels, 'Index');
if iscell(indices)
    indices = cell2mat(indices);
end
names       = CellWrap(get(channels, 'ChannelName'));