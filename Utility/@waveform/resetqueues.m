function obj = resetqueues(obj)
%
% RESETQUEUES Resets the queues of all the events in the waveform object
%
% RESETQUEUES(waveform) returns a modified version of <waveform> in which
% all the queues have been reset.
%
% $Id: resetqueues.m,v 1.2 2006/01/27 23:46:46 meliza Exp $

for i = 1:length(obj.channel_events)
    if ~isempty(obj.channel_events{i})
        obj.channel_events{i} = resetqueue(obj.channel_events{i});
    end
end