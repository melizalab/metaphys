function [] = SetDAQTrigger(triggertype, varargin)
%
% SETDAQTRIGGER Sets the triggering behavior for one or more data
% acquisition objects. 
%
% Triggering is how the data acquisition knows to start. Several trigger
% types are supported:
%
% 'manual'  The trigger() function is used to start acquisition after the
%           daq has been started, in response to user input or, in the case
%           of episodic acquisition, at fixed time intervals. Multiple daq
%           devices can be set by supplying a cell array of daq names.
%
%           SETDAQTRIGGER('manual', daqnames)
%
% 'linked'  Like 'manual', but used when input and output devices need to
%           start synchronously. This mode uses the 'ManualTriggerHwOn'
%           property of the analog input objects. NOTE: This does NOT mean
%           that the devices will be started simultaneously. As detailed in
%           the MATLAB documentation, what this allows you to do is use the
%           'InitialTriggerTime' property to align the input and output
%           start times.  This mode is not reccomended and is only included
%           here for completeness.
%
%           SETDAQTRIGGER('linked', aidaqname, aodaqname)
%
% 'hardware' A hardware trigger uses a special channel on the DAQ device to
%            initiate acquisition.  When a TTL signal is detected on this
%            channel, the device will be triggered. This is the fastest
%            form of triggering, and the best way to trigger off an
%            external source, like a Master-8 or external stimulator. Not
%            all hardware supports this mode.  On some hardware, like the
%            National Instruments MIO series analog input, you can specify
%            which channel to use for triggering.
%
%           SETDAQTRIGGER('hardware', daqname, [triggerchannel])
%
% 'digital' The digital trigger type is the only way to simultaneously
%           trigger multiple devices using a software command. It is like
%           the 'hardware' mode, but uses a digital i/o device to generate
%           the TTL pulse.  You will have to wire the digital signal into
%           the trigger channels, and specify which dio device to use to
%           generate the signal, and what digital line is connected to the
%           trigger port.
%
%           SETDAQTRIGGER('digital', daqname, triggerchannel, dioname, dioline)
%
% Not all possible triggering modes are supported here. This function is
% primarily for convenience, and to ensure that the triggering mode is a
% well-defined state (so that the user can select it from a list, among
% other reasons). The function is pretty good at cleaning up after itself,
% but it may be advisable to call RESETDAQ whenever possible.
%
% $Id: SetDAQTrigger.m,v 1.1 2006/01/10 20:59:50 meliza Exp $

switch lower(triggertype)
    case 'manual'
        daqnames = varargin{1};
        daqs     = GetDAQ(daqnames);
        set(daqs,'TriggerType','Manual')
        set(daqs,'UserData',[])
        for i = 1:length(daqs)
            if isfield(get(daqs(i)), 'ManualTriggerHwOn')
                set(daqs(i), 'ManualTriggerHwOn', 'Start')
            end
        end
    case 'linked'
        aidaq    = GetDAQ(varargin{1});
        aodaq    = GetDAQ(varargin{2});
        set([aidaq aodaq], 'TriggerType', 'Manual')
        set([aidaq aodaq], 'UserData', [])
        set(aidaq, 'ManualTriggerHwOn', 'Trigger')
    case 'hardware'
        daq      = GetDAQ(varargin{1});
        set(daq, 'TriggerType', 'HwDigital', 'UserData', [])
        if nargin > 2
            setTriggerChannel(daq, varargin{2})
        end
    case 'digital'
        daq         = GetDAQ(varargin{1});
        triggerchan = varargin{2};
        dio         = GetDAQ(varargin{3});
        dioline     = varargin{4};
        set(daq, 'TriggerType', 'HwDigital');
        if ~isempty(triggerchan)
            setTriggerChannel(daq, triggerchan)
        end
        % We store the dio device and the appropriate line(s) in the UserData
        % field of the daq; StartDAQ will have to look for this.
        set(daq, 'UserData', {dio dioline})
    otherwise
        error('METAPHYS:daq:noSuchTriggerType',...
            'No such trigger type %s has been defined in SETDAQTRIGGER',...
            triggertype)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = setTriggerChannel(daq, triggerchan)
% Sets the trigger channel if the hardware supports it.
if isfield(get(daq), 'HwDigitalTriggerSource')
    set(daq, 'HwDigitalTriggerSource', triggerchan)
else
    warning('METAPHYS:daq:operationNotSupported',...
        'The daq device %s does not support selectable trigger ports',...
        daq.name)
end