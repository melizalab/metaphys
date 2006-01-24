function [] = StartSweep(length, interval, varargin)
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
% STARTSWEEP(..., userdata) - If the DAQ is set to write, writes this data
% to disk.
%
% Throws an error if any of the daq devices is running.
%
% See Also: STOPDAQ, STARTCONTINOUS
%
% $Id: StartSweep.m,v 1.5 2006/01/25 01:58:37 meliza Exp $

% Get DAQ objects
daqs    = GetDAQ(GetDAQNames);
if nargin < 2 || isempty(interval)
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
                interval    = interval .* srate;
                set(daqs(i),...
                     'SamplesAcquiredFcnCount', interval,...
                     'SamplesAcquiredFcn', @DataHandler);
            end
        case 'analog output'
            set(daqs(i),'RepeatOutput',0);
    end
end

StartDAQ(daqs, varargin{:});    
    