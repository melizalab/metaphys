function events = getevents(obj, channel, event_ind)
%
% GETEVENTS Returns the waveformevent objects stored under a channel
%
% GETEVENTS(obj, channel) returns the waveformevent objects stored under
% <channel>. The channel may be referred to numerically or by name. If no
% events have been defined, or the channel does not exist, an empty array 
% is returned.
%
% GETEVENTS(obj, channel, events) returns only the events referred to by
% the indices in <events> (scalar or vector)
%
% $Id: getevents.m,v 1.1 2006/01/26 23:37:32 meliza Exp $

ind     = getchanindex(obj, channel);
events  = [obj.channel_events{ind}];
if nargin > 2
    ind     = intersect(1:length(events), event_ind);
    events  = events(ind);
end