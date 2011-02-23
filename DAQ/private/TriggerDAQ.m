function [] = TriggerDAQ(daq)
%
% TRIGGERDAQ    Triggers daq acquisition
%
% TRIGGERDAQ(daqobj) is called after a DAQ device has been started if the
% device needs to be triggered to begin acquisition. There are two
% situations where this is the case. If 'TriggerType' is set to 'Manual',
% then the function TRIGGER needs to be called. If 'TriggerType' is set to
% 'HwDigital' and there is a digital io device in the DAQ object's UserData
% field, then a TTL pulse needs to be sent on the dio device.
%
% It is safe to pass TRIGGERDAQ any kind of daqdevice object, including
% digital io devices. It will check for device type and for the triggertype
% property, and not attempt to trigger anything that can't handle it.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

% exclude digital io objects
types   = daq.Type;
analogs = strmatch('Analog',types);
daq     = daq(analogs);

ttypes      = daq.TriggerType;
man_trig    = strmatch('Manual', ttypes);
hard_trig   = strmatch('HwDigital', ttypes);
if ~isempty(hard_trig)
    dgline          = daq(hard_trig).UserData;
    if iscell(dgline)
        dgline      = [dgline{:}];
    end
else
    dgline  = [];
end

% actually do the triggering
if ~isempty(man_trig)
    trigger(daq(man_trig));
end
if ~isempty(dgline)
    putvalue(dgline,ones(size(dgline)));
    putvalue(dgline,zeros(size(dgline)));
end


