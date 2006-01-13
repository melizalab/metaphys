function [] = metaphys()
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
% $Id: metaphys.m,v 1.4 2006/01/14 00:48:04 meliza Exp $

initPath;
DebugSetOutput('console')
DebugPrint('Starting METAPHYS, $Revision: 1.4 $')
DebugPrint('Initialized METAPHYS path.')
% warning('off','MATLAB:dispatcher:CaseInsensitiveFunctionPrecedesExactMatch')
InitControl;
LoadControl;

createFigure;
updateFigure;

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
set(fig,'CloseRequestFcn',@close_metaphys);
%% Set callbacks on buttons
btns    = findobj(fig, 'style', 'pushbutton');
set(btns,'Callback',@button_push);
%% Init menus
cb      = @menu;
file    = uimenu(fig, 'label', '&File');
uimenu(file, 'label', '&Load Prefs...', 'tag', 'm_load_prefs', 'callback', cb)
uimenu(file, 'label', '&Save Prefs...', 'tag', 'm_save_prefs', 'callback', cb)
uimenu(file, 'label', 'Load &Instrument...', 'tag', 'm_load_instr',...
    'callback', cb, 'separator', 'on')
uimenu(file, 'label', 'Save Selected I&nstrument...', 'tag', 'm_save_instr',...
    'callback', cb)
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateFigure()
% Updates the uicontrols with the most current information.

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
if isempty(instruments)
    SetUIParam(mfilename,'instruments','String', ' ', 'Value', 1,...
        'Enable','Off')
else
    SetUIParam(mfilename,'instruments','String',instruments,...
       'Enable', 'On')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = close_metaphys(obj, event)
% Handles shutdown of the metaphys package.
DestroyControl

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = digitizer_props(obj, event)
% Handles selection and initialization of digitizer properties
DigitizerDialog

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = button_push(obj, event)
% Handles button pushes in the the figure.
tag     = get(obj,'tag');
switch tag
    case 'properties_digitizer'
        digitizer_props(obj, event)
    case 'data_dir_select'
        data_dir    = GetUIParam(mfilename, 'data_dir');
        if isempty(data_dir)
            data_dir    = getpref('METAPHYS','basedir');
        end
        pn          = uigetdir(data_dir,'Select Data Directory');
        if ~isnumeric(pn)
            SetUIParam(mfilename,'data_dir', pn);
            SetDefaults('data_dir','control', pn);
        end
    case 'data_prefix_select'
        protocol    = GetUIParam(mfilename, 'protocol');
        [pn fn ext] = fileparts(protocol);
        if isempty(pn)
            pn      = getpref('METAPHYS','basedir');
        end
        [fn pn]     = uigetfile({'*.m', 'Protocol Files (*.m)';...
            '*.*', 'All Files (*.*)'},...
            'Select Protocol...');
        if ~isnumeric(fn)
            SetUIParam(mfilename,'protocol', fn);
        end
    case 'instrument_add'
        nn  =   NewInstrumentName;
        InitInstrument(nn)
        InstrumentDialog(nn)
        updateInstruments;
    case 'instrument_edit'
        selected    = GetUIParam(mfilename,'instruments','Selected');
        if ~strcmpi(selected, ' ')
            InstrumentDialog(selected)
            updateInstruments
        end
    case 'instrument_delete'
        selected    = GetUIParam(mfilename,'instruments','Selected');
        if ~strcmpi(selected, ' ')
            DeleteInstrument(selected)
            updateInstruments
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
        SaveControl(fullfile(pn, fn))
    case 'm_save_instr'
        % instruments are stored in files with the same structure as used
        % by LOADCONTROL, but only use the instrument field.
        instrument  = GetUIParam(mfilename, 'instruments','Selected');
        if strcmpi(instrument, ' ')
            return
        end
        [fn pn] = uiputfile({'*.mcf', 'METAPHYS control file (*.mcf)';...
            '*.*',  'All Files (*.*)'},...
            'Save instrument to control file...');
        if ~isnumeric(fn)
            SaveInstrument(instrument, fullfile(pn, fn));
        end
    case 'm_load_instr'
        % instruments are stored in files with the same structure as used
        % by LOADCONTROL, but only use the instrument field. Only loads the
        % first instrument.
        [fn pn] = uigetfile({'*.mcf', 'METAPHYS control file (*.mcf)';...
            '*.*',  'All Files (*.*)'},...
            'Select instrument control file...');
        if ~isnumeric(fn)
            LoadInstrument(fullfile(pn, fn))
        end
        updateInstruments
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
        
    otherwise
        warning('METAPHYS:tagCallbackUndefined',...
            'The GUI object with tag %s made an unsupported callback.',...
            tag)
end
