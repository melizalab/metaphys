function obj    = addchannel(obj, channelname)
%
% ADDCHANNEL Adds a channel to the waveform object
%
% ADDCHANNEL(waveform, channelname) returns an updated waveform object with
% an additional channel with the name 'channelname' and with no events.
%
% ADDCHANNEL(waveform, numchans), but <numchans> channel names are
% generated automatically.
%
% $Id: addchannel.m,v 1.3 2006/01/30 20:05:03 meliza Exp $

if isnumeric(channelname)
    channelname     = makenewchannelnames(obj.channel_names, channelname);
elseif ischar(channelname)
    channelname    = {channelname};
end

empty_events         = cell(size(channelname));
obj.channel_names    = {obj.channel_names{:}, channelname{:}};
obj.channel_events   = {obj.channel_events{:}, empty_events{:}};


function cnames = makenewchannelnames(oldnames, cnum)
BASENAME = 'channel';
cnames   = cell([cnum 1]);

ind     = strmatch(BASENAME, oldnames);
if isempty(ind)
    new_ind = 1;
else
    names       = sort(oldnames(ind));
    lastnum     = sscanf(names{end},[BASENAME '%d']);
    if isempty(lastnum)
        new_ind = 1;
    else
        new_ind = lastnum + 1;
    end
end

for i = 1:cnum
    cnames{i}   = sprintf('%s%02.0f', BASENAME, new_ind);
    new_ind     = new_ind + 1;
end
