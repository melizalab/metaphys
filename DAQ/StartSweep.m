function [] = StartSweep(length, daqnames)
%
% STARTSWEEP Initiates data acquisition for a fixed length of time.
%
% STARTSWEEP(length) - All known DAQ devices are started, and if
% applicable, triggered. <length> is in seconds, not samples
%
% STARTSWEEP(length, daqnames) - Only the DAQ devices specified by
% <daqnames> are started.
%
% Throws an error if any of the daq devices is running.
%
% See Also: STOPDAQ
%
% $Id: StartSweep.m,v 1.1 2006/01/18 19:01:07 meliza Exp $

% Get DAQ objects
if nargin < 2
    daqs    = GetDAQ(GetDAQNames);
else
    daqs    = GetDAQ(daqnames);
end

% check for running objects
isrun   = daqs.Running;
if ~isempty(strmatch('On',isrun))
    error('METAPHYS:startsweep:deviceAlreadyRunning',...
        'One or more DAQ devices is currently running.')
end

% some properties are type-dependent
types   = CellWrap(daqs.Type);
ai      = daqs(strmatch('analog input', lower(types)));
ao      = daqs(strmatch('analog output', lower(types)));

for i = 1:size(ai,2)
    srate   = ai(i).SampleRate;
    % determine which devices to trigger
    ai_trig(i) = strcmpi(ai(i).TriggerType, 'manual');
    samp    = length .* srate;
    set(ai(i), 'SamplesPerTrigger', samp)
end

% Check AO devices for samples to be output and whether they need to be
% triggered
for i = 1:size(ao,2)
    ao_use(i)   = ao(i).SamplesAvailable > 0;
    ao_trig(i)  = strcmpi(ao(i).TriggerType, 'manual');
end

% set callbacks
data_cb  = @DataHandler;
msg_cb   = @daqcallback;

set(ai, 'SamplesAcquiredFcn', [],...
        'StartFcn', [],...
        'TimerFcn', [],...
        'TriggerFcn', msg_cb,...
        'DataMissedFcn', data_cb,...
        'RuntimeErrorFcn', data_cb,...
        'StopFcn', data_cb)
set(ao, 'SamplesOutputFcn', [],...
        'StartFcn', msg_cb,...
        'TimerFcn', [],...
        'TriggerFcn', msg_cb,...
        'RuntimeErrorFcn', msg_cb,...
        'StopFcn', msg_cb)
        
if size([ai ao(ao_use)],2) < 1
    DebugPrint('No DAQ devices to start!');
else
    start([ai ao(ao_use)])
end
if size([ai(ai_trig) ao(ao_use & ao_trig)],2) > 0
    trigger([ai(ai_trig) ao(ao_use & ao_trig)])
end
