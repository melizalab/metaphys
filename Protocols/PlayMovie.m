function varargout = PlayMovie(action)
%
% PLAYMOVIE Protocol that uses f21 to play a movie, recording a response
%
% The PLAYMOVIE protocol is used to supply visual stimulation to a system
% while recording its response. It uses f21 for the visual display and the
% normal DAQ functions for data collection.  F21 runs on a remote computer
% and is accessed through an f21control object.  Movies reside on the
% remote computer and can be set to play in one or more "objects" on the
% screen. F21 will report the amount of time required to play a movie and
% will collect that much data. The user can also specify voltage waveforms
% to send to amplifiers and stimulators during that time.
%
% See Also: F21CONTROL
%
% $Id: PlayMovie.m,v 1.6 2006/01/28 00:46:16 meliza Exp $

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
        % Open movie control
        movegui(MovieControl('init'),'northeast')
        varargout{1}    = f;
    
    case 'start'
        % Clear displays
        SweepDisplay('clearall')
        MovieControl('stop')
        DeleteSubscriber('loop')
        StopDAQ
        % Setup data handling
        SetDataStorage('memory')
        % Set system to repeat
        InitParam(me,'repeats','hidden')
        AddSubscriber('loop', [], @loopControl);
        % Call the sweep control function
        sweepControl
    
    case 'record'
        % Clear displays
        SweepDisplay('clearall')
        MovieControl('stop')
        DeleteSubscriber('loop')
        StopDAQ
        % Setup data handling
        dsmode  = GetParam(me, 'data_mode');
        instr   = GetParam(me, 'instrument');
        SetDataStorage(dsmode, instr)
        % Set system to repeat
        InitParam(me,'repeats','hidden')
        AddSubscriber('loop', [], @loopControl);
        % Call the sweep control function
        sweepControl
    
    case 'stop'
        % Stop system from repeating
        setStatus('protocol stopping');
        if IsDaqRunning
            AddSubscriber('loop', [], @cleanupControl)
        else
            cleanupControl
        end
        MovieControl('stop')
        
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
if strcmpi(packet.message.Type, 'stop')
    ep_interval      = GetParam(me,'ep_interval','value');
    tot_repeats      = GetParam(me,'movie_repeat','value');
    current_sweep    = GetSweepCounter;
    if current_sweep < tot_repeats
        SweepPause(ep_interval);
        sweepControl
    else
        cleanupControl(packet)
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = sweepControl()

% Queue movie
props           = MovieControl('prepare');
episodelength   = props.total_movie_time;
% Queue command data
queueStimulus(episodelength);
% Get update rate
uprate  = GetParam(me,'update_rate');
% Start a sweep
% StartSweep(episodelength,[],props)
% multiple updates don't work yet:
SweepDisplay('clearall', episodelength);
if isempty(uprate)
    StartSweep(episodelength,[],props)
else
    StartSweep(episodelength, 1000/uprate, props);
end
MovieControl('start')
setStatus('protocol running')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function queueStimulus(episodelength)
% Queues command data
waveform        = GetParam(me, 'waveform', 'value');
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
cleanupControl
% save current values to control structure
p   = GetParam(mfilename);
SetDefaults(mfilename,'control',p)
% delete display windows
DeleteModule('sweepdisplay')
DeleteModule('moviecontrol')
setStatus('protocol closed')
SetCurrentProtocol([])