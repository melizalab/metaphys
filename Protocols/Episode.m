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
% fig = EPISODE('init')
% EPISODE('start')
% EPISODE('record')
% EPISODE('stop')
% EPISODE('destroy')
%
% See also: EPISODE_DEFAULT
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

% Parse action
switch lower(action)
    case 'init'
        % Load default parameters for this protocol
        p = GetDefaults(me);
        p.instrument.choices    = GetInstrumentNames;
        p.instrument.callback   = @selectInstrument;
        % Open the parameter window
        f   = ParamFigure(me, p, @destroyModule);
        movegui(f,'east')
        instr   = GetParam(me, 'instrument');
        % Open the display scope
        SweepDisplay('init', instr, Inf);
        % Open statistics display
%         StatsDisplay('init', instr)
        varargout{1}    = f;
    
    case 'start'
        % Clear displays
        len = GetParam(me, 'ep_length', 'value');
        SweepDisplay('clearall', len)
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
        len = GetParam(me, 'ep_length', 'value');
        SweepDisplay('clearall', len)
%         StatsDisplay('clear')
        DeleteSubscriber('loop')
        StopDAQ
        % Setup data handling
        dsmode  = GetParam(me, 'data_mode');
        instr   = GetParam(me, 'instrument');
        SetDataStorage(dsmode, instr)
        WriteProtocolData(mfilename)
        % Set system to repeat
        AddSubscriber('loop', [], @loopControl)
        % Call the sweep control function
        sweepControl
    
    case 'stop'
        % Stop system from repeating
        SetStatus('protocol stopping');
        if IsDAQRunning
            AddSubscriber('loop', [], @cleanupControl)
        else
            cleanupControl
        end
        
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
if strcmpi(packet.message.Type, 'Stop')
    ep_interval     = GetParam(me,'ep_interval','value');
    ep_repeats      = GetParam(me,'ep_repeats','value');
    current_sweep   = GetSweepCounter;
    if current_sweep < ep_repeats
        SweepPause(ep_interval);
        sweepControl
    else
        cleanupControl(packet)
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = sweepControl()

% Queue command data
episodelength = queueStimulus;
% Start a sweep
StartSweep(episodelength)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function episodelength = queueStimulus()
% Queues command data. If the waveform is empty (ie invalid) then no call
% is made to putdata
waveform        = GetParam(me, 'waveform', 'value');
episodelength   = GetParam(me, 'ep_length', 'value');
if ~isempty(waveform)
    instr       = GetParam(me,'instrument');
    waveform    = PutInputWaveform(instr, episodelength, waveform);
    SetParam(me, 'waveform', waveform);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = cleanupControl(packet)
% Handles cleanup after last loop is done

% Stop acquisition
StopDAQ
% Set data storage to memory
SetDataStorage('memory')
DeleteSubscriber('loop')
waveform = GetParam(me, 'waveform', 'value');
waveform = resetqueues(waveform);
SetParam(me,'waveform',waveform);
SetStatus('protocol stopped')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = selectInstrument(varargin)
% handles when the user chooses a new instrument
DeleteSubscriber('loop')
StopDAQ
instr   = GetParam(me, 'instrument');
SetStatus('instrument changed: protocol stopped')
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
SetCurrentProtocol([])

