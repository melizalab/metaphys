function [] = EventHandler(obj, event)
%
% EVENTHANDLER   Handles events during acquisition.
%
% EVENTHANDLER is a daq callback switchyard. For each kind of event, it
% determines which handling functions need to be called: 
%
% Stop: resets analogoutput devices to default values, re-enables
%       acquisition UIcontrols and passes the event to DataHandler
% DataMissed, RuntimeError: Like Stop, but also prints a message to the
%                           console
% SamplesAcquired: Passes control to DataHandler
% Start: disables acquisition UIcontrols
% Trigger, all others: Does nothing
%
% See also: DATAHANDLER
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

switch event.Type
    case {'Stop'}
        ResetDAQOutput(obj, event);
        DataHandler(obj, event);
    case {'DataMissed', 'RuntimeError'}
        ResetDAQOutput(obj, event);
        EnableSensitiveControls('on');
        DataHandler(obj, event);
        daqcallback(obj, event);
    case 'SamplesAcquired'
        DataHandler(obj, event);
    case 'Start'
        EnableSensitiveControls('off');
end