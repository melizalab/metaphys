function obj = resetqueues(obj)
%
% RESETQUEUES Resets the queues of all the events in the waveform object
%
% RESETQUEUES(waveform) returns a modified version of <waveform> in which
% all the queues have been reset.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

for i = 1:length(obj.channel_events)
    if ~isempty(obj.channel_events{i})
        obj.channel_events{i} = resetqueue(obj.channel_events{i});
    end
end