function obj    = addevent(obj, channel, event)
%
% ADDEVENT Adds an event to a waveform object
%
% ADDEVENT(waveform, channel, event) returns a modified waveform object
% with the waveformevent object <event> added to <channel>. <Channel> may
% be a string or numeric.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if ~all(isa(event,'waveformevent'))
    error('METAPHYS:addevent:invalidArgument',...
        'Events must be waveformevent objects.');
end

ind     = getchanindex(obj, channel);
for i = 1:length(ind)
    events  = obj.channel_events{ind(i)};
    obj.channel_events{ind(i)} = [events event];
end