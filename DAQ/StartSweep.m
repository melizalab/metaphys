function [] = StartSweep(length, interval, daqnames)
%
% STARTSWEEP Initiates data acquisition for a fixed length of time.
%
% STARTSWEEP(length) - All known DAQ devices are started, and if
% applicable, triggered. <length> is in seconds, not samples
%
% This function should be used for acquiring sweeps of data with a fixed
% length. In practice, this length of time should be > 50 ms, as most
% hardware has trouble dealing with intervals shorter than that. The
% hardware will be set to acquire <length> seconds of data, at which point
% the device will stop logging and call DATAHANDLER.  If DATAHANDLER needs
% to be called more frequently, use the alternate form:
%
% STARTSWEEP(length, interval) - Acquires <length> seconds of data, but
% retrieves the data every <interval> seconds.
%
% STARTSWEEP(..., daqnames) - Only the DAQ devices specified by
% <daqnames> are started.
%
% Throws an error if any of the daq devices is running.
%
% See Also: STOPDAQ, STARTCONTINOUS
%
% $Id: StartSweep.m,v 1.2 2006/01/19 03:14:58 meliza Exp $

% Get DAQ objects
if nargin < 3
    daqs    = GetDAQ(GetDAQNames);
else
    daqs    = GetDAQ(daqnames);
end
if nargin < 2
    interval    = [];
end

% set acquisition times
types   = lower(daqs.Type);
for i = 1:size(types,1)
    switch types{i}
        case 'analog input'
            srate   = get(daqs(i), 'SampleRate');
            samp    = length .* srate;
            set(daqs(i),...
                        'SamplesPerTrigger', samp,...
                        'SamplesAcquiredFcn', []);
            if ~isempty(interval)
                set(daqs(i),...
                     'SamplesAcquiredFcnCount', samp,...
                     'SamplesAcquiredFcn', @DataHandler);
            end
        case 'analog output'
            set(daqs(i),'RepeatOutput',0);
    end
end
% ai      = strmatch('analog input', lower(daqs.Type));
% for i = 1:size(ai,1)
%     srate   = get(daqs(ai(i)), 'SampleRate');
%     samp    = length .* srate;
%     set(daqs(ai(i)), 'SamplesPerTrigger', samp,...
%                      'SamplesAcquiredFcn', []);
%     if ~isempty(interval)
%         set(daqs(ai(i)),... 
%                      'SamplesAcquiredFcnCount', samp,...
%                      'SamplesAcquiredFcn', @DataHandler);
%     end
% end

StartDAQ(daqs);    
    