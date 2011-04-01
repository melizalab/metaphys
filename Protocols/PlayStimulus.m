function varargout = PlayStimulus(action)
%
% PLAYSTIMULUS Protocol for acquiring data episodically; in each episode a
% pre-loaded output waveform is sent to one of the instrument's inputs
%
% fig = PLAYSTIMULUS('init')
% PLAYSTIMULUS('start')
% PLAYSTIMULUS('record')
% PLAYSTIMULUS('stop')
% PLAYSTIMULUS('destroy')
%
% See also: PLAYSTIMULUS_DEFAULT

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
        selectInstrument;  % opens display scope
        varargout{1}    = f;
    
    case 'start'
        DeleteSubscriber('loop')
        StopDAQ
        loadData;
        % Setup data handling
        SetDataStorage('memory')
        % Set system to repeat
        AddSubscriber('loop', [], @loopControl);
        % Call the sweep control function
        sweepControl
    
    case 'record'
        DeleteSubscriber('loop')
        StopDAQ
        loadData;
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
% 2011.03.18 MK
function [] = loadData()
% Load data from the stimulus file, center and rescale, and store
stimfile        = GetParam(me, 'stimulus', 'value');
maxposcur       = GetParam(me, 'max_pos_cur', 'value');
maxnegcur       = GetParam(me, 'max_neg_cur', 'value');
instr   = GetParam(me,'instrument');
chan    = GetParam(me,'data_output');
Fs      = GetChannelSampleRate(instr, chan) / 1000;
% should check sampling rate
if ~isempty(stimfile)
  stimdata      = LoadStimulusWaveform(stimfile);
  ind           = stimdata > 0.0;
  stimdata(ind) = stimdata(ind) * abs(maxposcur);
  stimdata(~ind) = stimdata(~ind) * abs(maxnegcur);
  SetParam(me, 'stim_cache', stimdata);
  DebugPrint('Loaded stimulus from %s, %d samples.', stimfile, ...
             length(stimdata));
  SweepDisplay('clearall', length(stimdata) / Fs);
else
  DebugPrint('No stimulus file to load');
  SetParam(me, 'stim_cache', []);
end

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
instr       = GetParam(me,'instrument');
chan        = GetParam(me,'data_output');
stimdata    = GetParam(me,'stim_cache');
if isempty(stimdata)
  DebugPrint('No stimulus loaded');  % should pop up a dialog
else
  episodelength = PutInputData(instr, stimdata, {chan});
  % Start a sweep
  StartSweep(episodelength)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = cleanupControl(packet)
% Handles cleanup after last loop is done
StopDAQ
% Set data storage to memory
SetDataStorage('memory')
DeleteSubscriber('loop')
SetStatus('protocol stopped')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = selectInstrument(varargin)
% handles when the user chooses a new instrument
DeleteSubscriber('loop')
StopDAQ
instr   = GetParam(me, 'instrument');
if ~isempty(instr)
    SetParam(me, 'data_output', 'choices',...
        GetInstrumentChannelNames(instr,'input'));
    ParamFigure(me)
end
SweepDisplay('init',instr, Inf);

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

