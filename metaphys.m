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
% $Id: metaphys.m,v 1.1 2006/01/10 20:59:49 meliza Exp $

DebugSetOutput('console')
DebugPrint('Starting METAPHYS, Version $Revision: 1.1 $')
initPath;
InitControl;
LoadControl;

createFigure;
initParams;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = initPath()
% Locates the directory where this mfile resides and adds it and its
% subdirectories to the path
DebugPrint('Initializing METAPHYS path.')
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
function [] = initParams()
% Initialize parameters for this module
% InitParam(mfilename,'data_prefix',struct('fieldtype','string','value',''));

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
keyboard

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
        end
    case 'm_save_prefs'
        [fn pn] = uiputfile({'*.mcf', 'METAPHYS control (*.mcf)';...
            '*.*',  'All Files (*.*)'},...
            'Save METAPHYS control information...');
        SaveControl(fullfile(pn, fn))
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
