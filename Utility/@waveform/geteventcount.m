function count  = geteventcount(obj, channel)
%
% GETEVENTCOUNT Returns the number of events defined on a channel
%
% GETEVENTCOUNT(waveform, channel) returns the number of events defined on
% <channel> (string or numeric)

ind     = getchanindex(obj, channel);
if isempty(ind)
    count   = 0;
else
    count   = length([obj.channel_events{ind}]);
end