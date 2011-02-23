function obj    = setevent(obj, channel, eventnum, event)
%
% SETEVENT Replaces an waveformevent object with a different one
%
% SETEVENT(obj, channel, eventnum, event) returns a modified object in
% which the event specified by channel/eventnum is replaced with <event>.
% <channel> (string or numeric) and <eventnum> (numeric) must refer to a
% single event.

ind     = getchanindex(obj, channel);
if length(ind) ~= 1 || length(eventnum) ~= 1
    error('METAPHYS:setevent:invalidArgument',...
        'Only a single event can be modified with %s',mfilename);
end
tot_events  = geteventcount(obj, ind);
if tot_events < eventnum
    error('METAPHYS:setevent:invalidArgument',...
        'There are only %d events for channel %d.', tot_events, ind);
end

obj.channel_events{ind}(eventnum)   = event;