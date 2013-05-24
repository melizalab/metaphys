function varargout = PlayStimulus(action)
%
% PLAYSTIMULUS Protocol for acquiring data episodically; in each episode a
% pre-loaded output waveform is sent to one of the instrument's inputs. The
% user can specify a single file with data in it, or a list of files which
% will be presented in turn.
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
        loadStimfile;
        % Setup data handling
        SetDataStorage('memory')
        % Set system to repeat
        AddSubscriber('loop', [], @loopControl);
        % Call the sweep control function
        sweepControl
    
    case 'record'
        DeleteSubscriber('loop')
        StopDAQ
        loadStimfile;
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
function [] = loadStimfile()
% Load the stimulus file and check it for consistency
SetParam(me, 'stim_list',{});
stimfile        = GetParam(me, 'stimulus', 'value');
if ~isempty(stimfile)
    [fid,msg] = fopen(stimfile,'rt');
    if fid < 0
        DebugPrint(['Error opening ' file ': ' msg]);
    else
        stimvals = textscan(fid, '%s%f', 'CommentStyle', '%');
        fclose(fid);
        DebugPrint(sprintf('%s: stimuli=%d',stimfile,length(stimvals{1}))); 
        SetParam(me, 'stim_list', stimvals);
    end
else
    DebugPrint('No stimulus file to load');
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [stimdata] = loadData(stimfile, samplerate)
% Load data from the stimulus file, center and rescale, and store
maxposcur       = GetParam(me, 'max_pos_cur', 'value');
maxnegcur       = GetParam(me, 'max_neg_cur', 'value');
ep_interval     = GetParam(me,'ep_interval','value');
instr   = GetParam(me,'instrument');
chan    = GetParam(me,'data_output');
Fs      = GetChannelSampleRate(instr, chan) / 1000;
% should check sampling rate
stimdata      = LoadStimulusWaveform(stimfile, samplerate, Fs);
ind           = stimdata > 0.0;
stimdata(ind) = stimdata(ind) * abs(maxposcur);
stimdata(~ind) = stimdata(~ind) * abs(maxnegcur);
% pad the signal with the silent interval
stimdata       = [stimdata; zeros(ep_interval * Fs,1)];
DebugPrint('Loaded stimulus from %s, %d samples.', stimfile, ...
           length(stimdata));
%SweepDisplay('clearall', length(stimdata) / Fs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = loopControl(packet)
if strcmpi(packet.message.Type, 'Stop')
    stim_list       = GetParam(me,'stim_list');
    ep_repeats      = GetParam(me,'ep_repeats','value');
    current_sweep   = GetSweepCounter;
    if (current_sweep / length(stim_list{1})) < ep_repeats;
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
stimpath    = fileparts(GetParam(me, 'stimulus', 'value'));
stim_list   = GetParam(me,'stim_list');
ep_repeats  = GetParam(me,'ep_repeats','value');
current_sweep   = GetSweepCounter;
if isempty(stim_list)
    DebugPrint('No stimuli');  % should pop up a dialog
else
    stim_num = mod(current_sweep, length(stim_list{1})) + 1;
    stimdata = loadData(fullfile(stimpath,stim_list{1}{stim_num}),...
        stim_list{2}(stim_num));
    episodelength = PutInputData(instr, stimdata, {chan});
    % Start a sweep
    StartSweep(episodelength,100)
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
% Open the display scope
ScopeDisplay('init', instr);
%SweepDisplay('init',instr, Inf);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = destroyModule(varargin)
% call stop action
cleanupControl;
% save current values to control structure
p   = GetParam(mfilename);
SetDefaults(mfilename,'control',p)
% delete display windows
DeleteModule('scopedisplay')
SetCurrentProtocol([])

