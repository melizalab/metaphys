function varargout = Episode(action)
%
% EPISODE Protocol for acquiring data episodically
%
% The METAPHYS toolkit works through modules, which are mfiles that control
% experiments of a similar type.  This module, EPISODE, is probably the
% most basic protocol, and should be used as an example for writing other
% modules.  In an episode, the data acquisition hardware is instructed to
% acquire data for a brief perioid of time, during which a signal can also
% be sent through the analogoutput device.  After a pause, the episode is
% repeated.  Individual episodes can be treated separately, or as is more
% common, averaged together to minimize noise.  Also, there are usually
% several parameters that can be extracted from each episode (e.g. input
% resistance); this module provides online tracking of these parameters
% (still somewhat limited.)
%
% EPISODE supports an arbitrary number of input and output channels. These
% channels are selected by defining an instrument with those channels on
% it. During each episode, data is acquired from the outputs of the
% instrument, and data is sent to the inputs. This sent data can be an
% arbitrary waveform, which can be loaded from a file or specified with a
% waveform editor (see WAVEFORMDIALOG).
%
% Note that when data is sent to an instrument it's important for the
% recorded data to be synchronized with the control waveform. This
% synchronization is controlled through triggers, which can be defined in
% the DIGITIZERDIALOG.
%
% EPISODE('init')
% EPISODE('start')
% EPISODE('record')
% EPISODE('stop')
% EPISODE('destroy')
%
% $Id: Episode.m,v 1.3 2006/01/25 01:31:40 meliza Exp $

% Parse action
switch lower(action)
    case 'init'
        % Load default parameters for this protocol
        p = GetDefaults(me);
        p.instrument.callback   = @selectInstrument;
        % Open the parameter window
        f   = ParamFigure(me, p, @destroyModule);
        movegui(f,'east')
        instr   = GetParam(me, 'instrument');
        % Open the display scope
        SweepDisplay('init', instr);
        % Open statistics display
%         StatsDisplay('init', instr)
        setStatus('protocol initialized');
    
    case 'start'
        % Clear displays
        SweepDisplay('clear')
%         StatsDisplay('clear')
        DeleteSubscriber('loop')
        StopDAQ
        % Setup data handling
        SetDataStorage('memory')
        % Set system to repeat
        AddSubscriber('loop', [], @loopControl);
        % Call the sweep control function
        sweepControl
    
    case 'record'
        % Clear displays
        SweepDisplay('clear')
%         StatsDisplay('clear')
        DeleteSubscriber('loop')
        StopDAQ
        % Setup data handling
        dsmode  = GetParam(me, 'data_mode');
        instr   = GetParam(me, 'instrument');
        SetDataStorage(dsmode, instr)
        % Set system to repeat
        AddSubscriber('loop', [], @loopControl)
        % Call the sweep control function
        sweepControl
    
    case 'stop'
        % Stop system from repeating
        setStatus('protocol stopping');
        AddSubscriber('loop', [], @cleanupControl)
        
    case 'destroy'
        destroyModule;
    otherwise
        error('METAPHYS:protocol:noSuchAction',...
            'No such action %s supported by protocol %s',...
            action, mfilename)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = me()
% This function is here merely for convenience so that
% the value 'me' refers to the name of this mfile (which
% is used in accessing parameter values)
out = mfilename;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = loopControl(packet)
ep_interval = GetParam(me,'ep_interval','value');
pause(ep_interval/1000);
sweepControl

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = sweepControl()

% Queue command data
episodelength = queueStimulus;
% Start a sweep
StartSweep(episodelength)
setStatus('protocol running')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function episodelength = queueStimulus()
% Queues command data
len = GetParam(me, 'ep_length', 'value');
episodelength = len / 1000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = cleanupControl(packet)
% Handles cleanup after last loop is done

% Stop acquisition
StopDAQ
% Set data storage to memory
SetDataStorage('memory')
DeleteSubscriber('loop')
setStatus('protocol stopped')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = setStatus(output)
SetUIParam('metaphys','protocol_status',output);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = selectInstrument(varargin)
% handles when the user chooses a new instrument
DeleteSubscriber('loop')
StopDAQ
instr   = GetParam(me, 'instrument');
setStatus('instrument changed: protocol stopped')
SweepDisplay('init',instr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = destroyModule(varargin)
% call stop action
cleanupControl;
% save current values to control structure
p   = GetParam(mfilename);
SetDefaults(mfilename,'control',p)
% delete display windows
DeleteModule('sweepdisplay')
setStatus('protocol closed')
