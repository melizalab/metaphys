function c = char(obj)
%
% CHAR Casts a WAVEFORM to a character event
%
% CHAR(waveform) returns the character string 'waveform: N/M events', where
% N is the number of channels and M is the number of events
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

for i = 1:length(obj)
    c(i,:)  = mychar(obj(i));
end


function c = mychar(obj)
N   = length(obj.channel_names);
if N > 0
    M   = sum(cellfun('length',obj.channel_events));
else
    M   = 0;
end

c   = sprintf('waveform: %d/%d events', N, M);