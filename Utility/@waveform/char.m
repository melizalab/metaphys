function c = char(obj)
%
% CHAR Casts a WAVEFORM to a character event
%
% CHAR(waveform) returns the character string 'waveform: N/M events', where
% N is the number of channels and M is the number of events
%
% $Id: char.m,v 1.1 2006/01/26 23:37:31 meliza Exp $

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