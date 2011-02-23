function [] = metaphys(action)
%METAPHYS The front end for the METAPHYS package
%
% The GUI does the following tasks before returning control the user.
%
% - Initialize path
% - Initialize control structure
% - Load preferences
%   - Initialize DAQ (according to preferences)
%   - Initialize any non-matlab drivers, activex controls, etc
% - Initialize GUI. User will set up DAQ preferences here
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if nargin > 0 && strcmpi(action,'destroy')
    %
else
    initPath;
    DebugSetOutput('console')
    DebugPrint('Starting METAPHYS, $Revision: 1.14 $')
    DebugPrint('Initialized METAPHYS path.')
    % warning('off','MATLAB:dispatcher:CaseInsensitiveFunctionPrecedesExactMatch')
    InitControl;
    LoadControl;

    createFigure;
    updateFigure;
    SetCurrentProtocol([])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = initPath()
% Locates the directory where this mfile resides and adds it and its
% subdirectories to the path
me      = mfilename('fullpath');
pn      = fileparts(me);
pathstr = genpath(pn);
warning('off','MATLAB:rmpath:DirNotFound')
rmpath(pathstr)
warning('on','MATLAB:rmpath:DirNotFound')
addpath(pathstr);
% Set the base directory in a preference
setpref('METAPHYS', 'basedir', pn);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = createFigure()
% Generates the MetaPhys figure window and the UI controls
%% Open the figure
DebugPrint('Opening main METAPHYS window.')
fig = OpenGuideFigure(mfilename);
movegui(fig,'northwest');
set(fig,'units','normalized','CloseRequestFcn',@close_metaphys);
%% Set callbacks on buttons
btns    = findobj(fig, 'style', 'pushbutton');
set(btns,'Callback',@button_push);
%% Set callback on instrument selection
SetUIParam(mfilename, 'instruments', 'Callback', @selectInstrument)
%% Init menus
cb      = @menu;
file    = uimenu(fig, 'label', '&File');
uimenu(file, 'label', '&Load Prefs...', 'tag', 'm_load_prefs', 'callback', cb)
uimenu(file, 'label', '&Save Prefs...', 'tag', 'm_save_prefs', 'callback', cb)
uimenu(file, 'label', 'Data File &Prefix...', 'tag', 'm_set_prefix',...
    'callback', cb, 'separator', 'on')
uimenu(file, 'label', 'E&xit', 'tag', 'm_exit', 'callback', cb,...
    'separator', 'on')

hardw   = uimenu(fig, 'label', '&Hardware');
uimenu(hardw, 'label', 'Digitizer &Properties...', 'tag', 'm_dig_props',...
    'callback', cb)
uimenu(hardw, 'label', '&Reset Digitizer(s)', 'tag', 'm_dig_reset',...
    'callback', cb)
uimenu(hardw, 'label', '&Visual Stimulator Setup...', 'tag', 'm_vis_props',...
    'callback', cb, 'separator', 'on')

help    = uimenu(fig, 'label', 'H&elp');
uimenu(help, 'label', '&METAPHYS Help', 'tag', 'm_help_metaphys',...
    'callback', cb)
uimenu(help, 'label', 'MATLAB &Help', 'tag', 'm_help_matlabl',...
    'callback', cb)
uimenu(help, 'label', '&About METAPHYS', 'tag', 'm_about_metaphys',...
    'callback', cb, 'separator', 'on')

%% Make the input panel
makeInputPanel

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = makeInputPanel()
%% Generates the hold input panel, which is where the user can set default
%% values for an instrument's inputs
N_INPUTS    = 5;
pnlh        = GetUIHandle(mfilename,'inputs_pnl');
x           = 0.024;    % start x
y           = 0.832;    % start y
h           = 0.11;     % control height
hh          = 0.06;     % gap
shim        = 0.01;
w_chk       = 0.55;
w_edt       = 0.28;
w_unt       = 0.11;
ww          = 0.01;
c           = get(0,'defaultUicontrolBackgroundColor');
% IMPORTANT: these objects need to be disabled when a protocol is running
for i = 1:N_INPUTS
    InitUIControl(pnlh, mfilename, sprintf('input%d_name', i),...
        'style', 'text', 'String', sprintf('input%d', i),...
        'BackgroundColor', c, 'HorizontalAlignment', 'left',...
        'Units','normalized',...
        'Position', [x y w_chk h]);
    InitUIControl(pnlh, mfilename, sprintf('input%d_value', i),...
        'style', 'edit', 'String', '',...
        'Units','normalized',...
        'Position', [x+w_chk+ww y+shim w_edt h], 'Callback', @updateHoldVal);
    InitUIControl(pnlh, mfilename, sprintf('input%d_units', i),...
        'style', 'text', 'String', '', 'BackgroundColor', c,...
        'Units','normalized',...
        'Position', [x+w_chk+ww+w_edt+ww y w_unt h]);
    y   = y - h - hh;
end
hndl      = get(pnlh,'Children');
set(hndl, 'Visible', 'off')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = selectInstrument(varargin)
%% handles instrument selection event
instrument  = GetUIParam(mfilename, 'instruments', 'selected');
%% start with all inputs invisible
pnlh        = GetUIParam(mfilename,'inputs_pnl','Children');
set(pnlh, 'Visible', 'Off');
%% display up to N inputs and their current hold values
N_INPUTS    = 5;
if ~isempty(instrument)
    inputs  = GetInstrumentChannelNames(instrument, 'input');
    if length(inputs) < N_INPUTS
        N_INPUTS    = length(inputs);
    end
    for i = 1:N_INPUTS
        chan    = inputs{i};      
        hold    = GetInstrumentChannelProps(instrument, chan,...
            'DefaultChannelValue');
        units   = GetInstrumentChannelProps(instrument, chan, 'Units');
        SetUIParam(mfilename, sprintf('input%d_name', i),...
            'String', chan, 'Visible', 'On');
        SetUIParam(mfilename, sprintf('input%d_value',i),...
            'String', num2str(hold), 'UserData', chan,...
            'Visible', 'On');
        SetUIParam(mfilename, sprintf('input%d_units',i),...
            'String', units, 'Visible', 'On');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateHoldVal(obj, event)
%% called when the user updates the hold value: finds the relevant
%% instrument input and sets its default value to that value
tag = get(obj, 'tag');
instr   = GetUIParam(mfilename, 'instruments', 'Selected');
channel = GetUIParam(mfilename, tag, 'UserData');
value   = GetUIParam(mfilename, tag, 'StringVal');
if ~isempty(value)
    SetInstrumentChannelProps(instr, channel, 'DefaultChannelValue', value)
    ResetDAQOutput
end
selectInstrument
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateFigure()
%% Updates the uicontrols with the most current information.

%% Easy stuff:
data_dir        = GetDefaults('data_dir');
if isempty(data_dir)
    data_dir    = getpref('METAPHYS', 'basedir');
end
SetUIParam(mfilename, 'data_dir', data_dir)

%% Instruments and Channels
updateInstruments

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateInstruments()
% Updates the instrument list
instruments = GetInstrumentNames;
SetUIParam(mfilename,'instruments','String',instruments)
h           = GetUIHandle(mfilename,{'protocol_init', 'seal_test',...
    'protocol_start', 'protocol_record'});
if isempty(instruments)
	set(h,'enable','off')
elseif isempty(GetCurrentProtocol)
	set(h(1:2),'enable','on')
    selectInstrument
else
	set(h,'enable','on')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = close_metaphys(obj, event)
% Handles shutdown of the metaphys package.
DestroyControl

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = digitizer_props(obj, event)
% Handles selection and initialization of digitizer properties
DigitizerDialog('init');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = button_push(obj, event)
% Handles button pushes in the the figure.
tag             = get(obj,'tag');
current_prot    = GetCurrentProtocol;
switch tag
    case 'properties_digitizer'
        digitizer_props(obj, event)
    case 'data_dir_select'
        data_dir    = GetUIParam(mfilename, 'data_dir');
        if isempty(data_dir)
            data_dir    = getpref('METAPHYS','basedir');
        end
        pn          = uisetdatadir(data_dir);
        if ~isnumeric(pn)
            SetUIParam(mfilename,'data_dir', pn);
            SetDefaults('data_dir','control', pn);
        end
    case 'protocol_select'
        protocol    = GetUIParam(mfilename, 'protocol','userdata');
        [pn fn ext] = fileparts(char(protocol));
        if isempty(pn)
            pn      = getpref('METAPHYS','basedir');
        end
        pwd         = cd(pn);
        [fn pn]     = uigetfile({'*.m', 'Protocol Files (*.m)';...
            '*.*', 'All Files (*.*)'},...
            'Select Protocol...');
        cd(pwd);
        if ~isnumeric(fn)
            SetUIParam(mfilename,'protocol', 'string', fn,...
                'userdata', fullfile(pn,fn))
            if ishandle(current_prot)
                delete(current_prot)
            else
                SetCurrentProtocol([])
            end
        end
    case 'instrument_add'
        nn  =   NewInstrumentName;
        InitInstrument(nn)
        InstrumentDialog('modal',nn)
        updateInstruments;
    case 'instrument_edit'
        selected    = GetUIParam(mfilename,'instruments','Selected');
        if ~isempty(strtrim(selected))
            InstrumentDialog('modal',selected)
            updateInstruments
        end
    case 'instrument_delete'
        selected    = GetUIParam(mfilename,'instruments','Selected');
        if ~strcmpi(selected, ' ')
            DeleteInstrument(selected)
            updateInstruments
        end
    case 'seal_test'
        SealTest('init')
    case 'protocol_init'
        protocol    = GetUIParam(mfilename, 'protocol');
        if ~isempty(protocol)
            [pn fn ext] = fileparts(protocol);
            pfunc       = str2func(fn);
            fhandle     = pfunc('init');
            SetCurrentProtocol(fhandle);
        end
    case 'protocol_start'
        protocol    = GetUIParam(mfilename, 'protocol');
        if ~isempty(protocol)
            [pn fn ext] = fileparts(protocol);
            pfunc       = str2func(fn);
            pfunc('start')
        end
    case 'protocol_stop'
        protocol    = GetUIParam(mfilename, 'protocol');
        if ~isempty(protocol) || ~isempty(current_prot)
            [pn fn ext] = fileparts(protocol);
            pfunc       = str2func(fn);
            pfunc('stop')
        else
            StopDAQ
        end
    case 'protocol_record'
        protocol    = GetUIParam(mfilename, 'protocol');
        if ~isempty(protocol)
            [pn fn ext] = fileparts(protocol);
            pfunc       = str2func(fn);
            pfunc('record')
        end
    otherwise
        DebugPrint('No action has been described for the callback on %s.',...
            tag)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = menu(obj, event)
% Handles menu selections
tag = get(obj, 'tag');
switch tag
    case 'm_load_prefs'
        [fn pn] = uigetfile({'*.mcf', 'METAPHYS control file (*.mcf)';...
            '*.*',  'All Files (*.*)'},...
            'Select METAPHYS control file...');
        if ~isnumeric(fn)
            LoadControl(fullfile(pn, fn))
            updateFigure
        end
    case 'm_save_prefs'
        [fn pn] = uiputfile({'*.mcf', 'METAPHYS control (*.mcf)';...
            '*.*',  'All Files (*.*)'},...
            'Save METAPHYS control information...');
        if ~isnumeric(fn)
            SaveControl(fullfile(pn, fn))
        end
    case 'm_set_prefix'
        % We are sort of fudging the use of GETDEFAULTS here, since it's
        % normally used to store structures.
        prefix  = GetDefaults('data_prefix');
        answer  = inputdlg({'Enter data file prefix:'},...
            'Data prefix', 1, {char(prefix)});
        if ~isempty(answer)
            SetDefaults('data_prefix','control',answer{1})
        end
    case 'm_exit'
        % Pass to close function
        close_metaphys(obj, event)
        
    case 'm_dig_props'
        % Pass to digitizer function
        digitizer_props(obj, event)
    case 'm_dig_reset'
        ResetDAQ
        
    case 'm_vis_props'
        prefix  = GetDefaults('vis_remote_host');
        answer  = inputdlg({'Enter remote f21 host address:'},...
            'Remote Host Address', 1, {char(prefix)});
        if ~isempty(answer)
            SetDefaults('vis_remote_host','control',answer{1})
        end
        
    otherwise
        warning('METAPHYS:tagCallbackUndefined',...
            'The GUI object with tag %s made an unsupported callback.',...
            tag)
end

