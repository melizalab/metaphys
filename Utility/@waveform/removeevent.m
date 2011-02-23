function obj = removeevent(obj, channel, eventnum)
%
% REMOVEEVENT Removes an event from a waveform object
%
% REMOVEEVENT(obj, channel, eventnum) Returns a modified object in which
% the events referred to by <eventnum> (scalar or vector) are removed from
% the channel <channel> (string or numeric)
%
% If the channel or event do not exist, no error is thrown.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

ind     = getchanindex(obj, channel);
for i = 1:length(ind)
    events      = obj.channel_events{ind(i)};
    event_nums  = 1:length(events);
    new_ind     = setdiff(event_nums, eventnum);
    obj.channel_events{ind(i)} = events(new_ind);
end