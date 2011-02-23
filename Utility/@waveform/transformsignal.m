function [X, obj] = transformsignal(obj, T, X, channel)
%
% TRANSFORMSIGNAL Applies the waveform to a signal
%
% [Z, waveform] = TRANSFORMSIGNAL(waveform, T, X) applies the events stored
% in <waveform> to the signal defined by T and X. T is an Nx1 time vector,
% and X is a NxM array of signal data. The number of channels in X (M) must
% be equal to the number of channels defined in the waveform object. If the
% values are not the same, the extra channels will be ignored.
%
% [Z, waveform] = TRANSFORMSIGNAL(waveform, T, X, channels) applies the
% transform only on the channels specified by 'channels' (cell, string, or
% numeric index). X should have only one channel; others will be ignored.
%
% TRANSFORMSIGNAL uses internal queues to successively generate new trials.
% Each time TRANSFORMSIGNAL is called, the queue data is updated, so that
% if a cycle of event parameters is defined, successive calls to
% TRANSFORMSIGNAL will return signals updated using the new parameter
% values.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if nargin < 4
    channel = getchannelnames(obj);
elseif ischar(channel)
    channel = {channel};
end

inputchans  = size(X,2);
wavefchans  = length(channel);

for p = 1:wavefchans
    i = channel(p);
    if p <= inputchans
        events  = obj.channel_events{i};
        for j = 1:length(events)
            [X(:,p), events(j)] = generatesweep(events(j), T, X(:,p));
        end
        obj.channel_events{i} = events;
    end
end
    
