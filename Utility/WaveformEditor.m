function varargout = WaveformEditor(action, varargin)
%
% WAVEFORMEDITOR Dialog for specifying waveforms for output to instruments
%
% The WAVEFORMEDITOR dialog is used to create and edit analog waveforms. An
% arbitrary number of channels can be specified. The waveform is developed
% by specifying events, which are characterized by their onset, duration,
% and amplitude.  These values can be fixed or can vary from trial to
% trial. For instance, it may be desirable to step through a variety of
% voltage steps to measure an I-V curve.
%
% fig   = WAVEFORMEDITOR('init', [waveform]) - starts the editor in
%                                                standalone mode
% wave  = WAVEFORMEDITOR('modal', [waveform]) - starts in modal mode
%
% WAVEFORMEDITOR('destroy')
%
% $Id: WaveformEditor.m,v 1.3 2006/01/30 20:05:02 meliza Exp $

switch lower(action)
    case 'init'
        varargout{1} = createFigure;
        updateFigure(varargin{:})
    case 'modal'
        fig = createFigure;
        updateFigure(varargin{:})
        uiwait(fig)
        varargout{1}    = getpref('METAPHYS','currentWaveform',{[]});
    case 'destroy'
        fig = FindFigure(mfilename);
        if ~isempty(fig) && ishandle(fig)
            delete(fig)
        end
    otherwise
        error('METAPHYS:unrecognizedAction',...
            'Unrecognized action (%s)', action)
end

function [] = makePreview(varargin)
% the preview depends on what the user has selected.  Only one channel can
% be selected, but multiple events can be. If multiple events are selected,
% they are applied in the order in the waveform structure
PREVIEW_RES = 1;
[events]    = getEvent;

if ~isempty(events)
    % figure out how long the preview needs to be
    times       = geteventlength(events);
    maxlen      = max(times(:,2));
    if isempty(maxlen) || isnan(maxlen)
        warndlg({'No valid events were selected.',...
            'Events must have onset, duration, and amplitude defined.'})
    else
        T       = (0:PREVIEW_RES:(maxlen * 1.1))';
        X       = zeros(size(T));
        for i = 1:length(events)
            if isvalid(events(i))
                X   = applyevent(events(i), T, X, 'unique');
            end
        end
        ax      = GetUIHandle(mfilename, 'preview_axes');
        ph      = plot(ax,T, X,'b');
        grid(ax,'on');
        xlabel('Time (ms)');
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [event wvs chan sel] = getEvent()
wvs     = GetUIParam(mfilename,'channel_list','userdata');
sel     = GetUIParam(mfilename,'event_list','value');
chan    = GetUIParam(mfilename,'channel_list','value');
event   = getevents(wvs, chan, sel);

function [] = setEvent(event)
% replaces the currently selected event with the argument
sel     = GetUIParam(mfilename,'event_list','value');
chan    = GetUIParam(mfilename,'channel_list','value');
wvs     = GetUIParam(mfilename,'channel_list','userdata');
wvs     = setevent(wvs, chan, sel, event);
SetUIParam(mfilename,'channel_list','userdata',wvs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = buttonHandler(varargin)
% handles button presses
tag = get(varargin{1}, 'tag');
[event wvs chan sel] = getEvent;
switch tag
    case 'event_remove'
        if ~isempty(event)
            wvs         = removeevent(wvs, chan, sel);
            updateFigure(wvs)
        end
    case 'event_add'
        new_event           = waveformevent;
        wvs                 = addevent(wvs, chan, new_event);
        updateFigure(wvs)
    case {'onset_func_pick', 'ampl_func_pick', 'dur_func_pick',...
            'user_func_pick'}
        tn  = tag(1:end-4);
        basedir = getpref('METAPHYS','basedir');
        wd = cd(basedir);
        [pn fn] = uigetfile({'*.m', 'MATLAB functions (*.m)'},...
            'Select Function');
        cd(wd);
        if ~isnumeric(fn)
            fhandle = str2func(fn);
            SetUIParam(mfilename, tn, 'string', sprintf('@%s', fn));
        else
            fhandle = [];
            SetUIParam(mfilename, tn, 'string', '');
        end
        event = set(event, tn, fhandle);
        setEvent(event);
    case {'onset', 'ampl', 'dur'}
        val = GetUIParam(mfilename, tag, 'stringval');
        event = set(event, tag, val);
        setEvent(event);
    case 'cycle_mode'
        val = GetUIParam(mfilename, tag, 'selected');
        event = set(event, tag, val);
        setEvent(event);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = pickEvent(varargin)
[event] = getEvent;
hand   = getSensitiveObjects;

if length(event) == 1

    props   = get(event);
    fn      = fieldnames(props);
    for i = 1:length(fn)
        h   = findobj(gcf,'tag',fn{i});
        if ~isempty(h)
            if isa(props.(fn{i}),'function_handle')
                str     = sprintf('@%s', func2str(props.(fn{i})));
                set(h,'String',str)
            elseif strcmpi(get(h,'style'),'popupmenu')
                SetUIParam(mfilename,fn{i},'selected',props.(fn{i}));
            else
                str     = num2str(props.(fn{i})');
                set(h,'String',str)
            end
        end
    end
    set(hand,'Enable','On');
else
    set(hand,'Enable','Off');
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = pickChannel(varargin)
% handles what happens when the user picks a channel
channel = GetUIParam(mfilename, 'channel_list', 'Value');
wvfrm   = GetUIParam(mfilename, 'channel_list', 'userdata');

num_events  = geteventcount(wvfrm, channel);
if num_events > 0
    event_list  = num2str((1:num_events)');
    SetUIParam(mfilename,'event_list','string',event_list,'value',1,...
        'enable','on')
    pickEvent;
else
    h       = getSensitiveObjects;    
    set(h,'enable','off')
    SetUIParam(mfilename,'event_list','string','','enable','off')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateFigure(wavefrm)
% updates the values in the figure
chans   = GetUIParam(mfilename,'channel_list','string');
nchans  = size(chans,1);
% if no waveform, generate an empty object
if nargin < 1 || isempty(wavefrm)
    wavefrm    = waveform(chans);
else
    wchans  = getchannelcount(wavefrm);
    if nchans > wchans
        wavefrm    = addchannel(wavefrm, nchans - wchans);
    elseif nchans < wchans
        wavefrm    = removechannel(wavefrm, (nchans+1):wchans);
        warndlg({'The waveform has more channels than the instrument.',...
            'Additional channels in the waveform will not be shown.'})
    end
end
SetUIParam(mfilename,'channel_list','userdata', wavefrm);
pickChannel;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = menu(varargin)
tag = get(varargin{1},'tag');
switch tag
    case 'm_load'
        [fn pn] = uigetfile({'*.wvf', 'Waveform file (*.wvf)';...
            '*.*', 'All files (*.*)'},'Select a waveform file');
        if ~isnumeric(fn)
            z   = load('-mat', fullfile(pn,fn));
            if ~isempty(z) && isfield(z, 'waveform')
                updateFigure(z.waveform);
                DebugPrint('Loaded waveform data from %s.', fullfile(pn, fn));
            else
                errordlg({'Invalid waveform file!'});
            end
        end
    case 'm_save'
        [fn pn] = uiputfile({'*.wvf', 'Waveform file (*.wvf)';...
            '*.*', 'All files (*.*)'},'Select a waveform file');
        if ~isnumeric(fn)
            [pn fn] = fileparts(fullfile(pn, fn));
            waveform    = GetUIParam(mfilename,'channel_list','userdata');
            filename    = fullfile(pn, [fn '.wvf']);
            save(filename, 'waveform', '-mat');
            DebugPrint('Wrote waveform events to %s.', filename);
        end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fig = createFigure

fig     = OpenGuideFigure(mfilename);
set(fig,'DeleteFcn', @handleCleanup)
% Setup menu
cb      = @menu;
file    = uimenu(fig, 'label', '&File');
uimenu(file, 'label', '&Load Waveform...', 'tag', 'm_load', 'callback', cb)
uimenu(file, 'label', '&Save Waveform...', 'tag', 'm_save', 'callback', cb)
uimenu(file, 'label', 'E&xit', 'tag', 'm_exit', 'callback', 'closereq',...
    'separator', 'on')

% set callbacks
SetUIParam(mfilename, 'channel_list', 'Callback', @pickChannel)
SetUIParam(mfilename, 'event_list', 'Callback', @pickEvent)
SetUIParam(mfilename, 'refresh', 'Callback', @makePreview)

tags    = {'event_add', 'event_remove',...
    'onset_func_pick', 'ampl_func_pick', 'dur_func_pick', 'user_func_pick',...
    'onset', 'ampl', 'dur', 'cycle_mode'};
handles = GetUIHandle(mfilename, tags);
set(handles,'callback',@buttonHandler);

% set channel list
instr       = GetCurrentInstrumentName;
channels    = GetInstrumentChannelNames(instr, 'input');
SetUIParam(mfilename,'channel_list',channels);

cycle_modes = {'single', 'multi', 'random', 'shuffle'};
SetUIParam(mfilename,'cycle_mode', 'string', cycle_modes, 'value', 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handles    = getSensitiveObjects()
tags    = {'onset_func_pick', 'ampl_func_pick', 'dur_func_pick',...
    'user_func_pick',...
    'onset', 'ampl', 'dur', 'cycle_mode'};
handles = GetUIHandle(mfilename, tags);


function [] = handleCleanup(varargin)
% writes the current waveform to a pref before exiting
[event wvs] = getEvent;
setpref('METAPHYS', 'currentWaveform', wvs);