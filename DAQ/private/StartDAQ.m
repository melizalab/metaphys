function [] = StartDAQ(daqs)
%
% STARTDAQ Initiates data acquisition.
%
% STARTDAQ(daqobjs) - Starts all the device objects
%
%
% Handles starting and triggering (if needed) of devices.
% Throws an error if any of the daq devices is running.
%
% See Also: STOPDAQ
%
% $Id: StartDAQ.m,v 1.1 2006/01/19 03:15:00 meliza Exp $


% check for running objects
isrun   = daqs.Running;
if ~isempty(strmatch('On',isrun))
    error('METAPHYS:startsweep:deviceAlreadyRunning',...
        'One or more DAQ devices is currently running.')
end

% check to see which devices need started and triggered
do_start    = ones(size(daqs));
do_trigger  = zeros(size(daqs));
types       = lower(daqs.Type);

% set callbacks
data_cb  = @DataHandler;
% msg_cb   = @daqcallback;
msg_cb   = [];

for i = 1:length(types)
    switch types{i}
        case 'digital io'
            do_start(i) = 0;
        case 'analog output'
            if daqs(i).SamplesAvailable < 1 || ...
                    isempty(daqs(i).Channel)
                do_start(i) = 0;
            elseif strcmpi('manual',daqs(i).TriggerType)
                do_trigger(i)   = 1;
            end
            set(daqs(i),...
                    'SamplesOutputFcn', [],...
                    'StartFcn', msg_cb,...
                    'TimerFcn', [],...
                    'TriggerFcn', msg_cb,...
                    'RuntimeErrorFcn', msg_cb,...
                    'StopFcn', @ResetDAQOutput)
        case 'analog input'
            if isempty(daqs(i).Channel)
                do_start(i) = 0;
            elseif strcmpi('manual',daqs(i).TriggerType)
                do_trigger(i)   = 1;
            end
            set(daqs(i),...
                    'StartFcn', [],...
                    'TimerFcn', [],...
                    'TriggerFcn', msg_cb,...
                    'DataMissedFcn', data_cb,...
                    'RuntimeErrorFcn', data_cb,...
                    'StopFcn', data_cb)
    end
end
            
if ~any(do_start)
    DebugPrint('No DAQ devices to start!');
else
    start(daqs(find(do_start)))
    if any(do_start & do_trigger)
        trigger(daqs(find(do_start & do_trigger)))
    end
end

