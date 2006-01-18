function [] = StartContinuous(interval, loop, daqnames)
%
% STARTCONTINUOUS Starts a continuous acquisition.
%
% STARTCONTINOUS(interval) - All known DAQ devices are started. Every
% <interval> seconds, DATAHANDLER will be triggered to retrieve data.
%
% STARTSWEEP(interval, loop) - If there are any analogoutput objects
% active, their output will be repeated <loop> times. If <loop> is Inf, the
% queued data will repeat until the device is stopped (default).
%
% STARTSWEEP(interval, loop, daqnames) - Only the DAQ devices specified by
% <daqnames> are started.
%
% Throws an error if any of the daq devices is running.
%
% See Also: STOPDAQ, STARTSWEEP
%
% $Id: StartContinuous.m,v 1.1 2006/01/19 03:14:58 meliza Exp $

% Get DAQ objects
if nargin < 3
    daqs    = GetDAQ(GetDAQNames);
else
    daqs    = GetDAQ(daqnames);
end
if nargin < 2
    loop    = Inf;
end

% set acquisition times
types   = lower(daqs.Type);
for i = 1:size(types,1)
    switch types{i}
        case 'analog input'
            srate   = get(daqs(i), 'SampleRate');
            samp    = interval .* srate;
            set(daqs(i),...
                'SamplesPerTrigger', Inf,...
                'SamplesAcquiredFcnCount', samp,...
                'SamplesAcquiredFcn', @DataHandler);
        case 'analog output'
            set(daqs(i),'RepeatOutput',loop);
    end
end
StartDAQ(daqs);