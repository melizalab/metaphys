function varargout = ParamFigure(module, varargin)
%
% PARAMFIGURE Opens or updates a parameter figure window. 
%
% The parameter figure specialized dialogue used to manipulate module
% parameters without the necessity of programming callbacks or using
% UIParams.  When the user edits the value in the GUI the corresponding
% value in the control structure is altered, accessible through GETPARAM.
% Unlike UIParams, however, the parameter figure is NOT updated by calls to
% SETPARAM. In order to update the parameter figure, PARAMFIGURE needs to
% be called without the properties argument, as follows:
%
% fig = PARAMFIGURE(module): updates the parameter figure with values in
%                            the control structure.
%
% To initialize a parameter figure with new properties:
%
% fig = PARAMFIGURE(module,[properties,[close_callback]])
%
% module     - the module (string tag) responsible for these parameters
% properties - properties is a structure of structures; each of the subordinate 
%              structures should conform to the param_struct header, and the name
%              of each of these fields is the tag for the parameter.  Thus, for a
%              struct with the following structure
%
%              s.test = struct('fieldtype','String','value','test')
%
%              the call GETPARAM(module, 'test', 'value') will return 'test')
%
% close_callback  - this callback is attached to the DeleteFcn callback of the Param
%                   window, allowing the user/programmer to specify some action to take
%                   when the parameter window is closed
%
% If PARAMFIGURE is called without the properties argument, the properties
% already in the control structure are used to update/open the figure. If
% properties are supplied, the parameter figure will be destroyed and
% reinitialized. Note that if there is an action associated with closing
% the parameter window, that will be executed.
%
% See Also: PARAM_STRUCT, GETPARAM
%
% $Id: ParamFigure.m,v 1.5 2006/01/26 23:37:28 meliza Exp $ 

module  = lower(module);

fig   = FindFigure([module '.param']);
if nargin > 1
    delete(fig(ishandle(fig)));
    InitModule(module)
    fig = newFigure(module, varargin{:});
else
    params  = GetParam(module);
    setParams(module, params);
end
varargout{1}    = fig;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fig] = newFigure(module, params, close_callback)
% Opens a new parameter figure window and sets up the fields for each 
% of the parameters. Each editable uicontrol is given a tag 'module.param',
% so it can be located easily later.

% set the close callback if not supplied
if nargin < 3
    close_callback = [];
end

tag = [module '.param'];
% units are in pixels for my sanity
w_fn = 100;
w_f = 90;
w_units = 15;
h = 23;
x_pad = 5;
y_pad = 5;

%% Open figure
fig = figure('name',tag,'tag',tag,'deletefcn',close_callback);
SetObjectDefaults(fig, 'paramfigure');

%% Init params
InitParam(module, params);

%% Init fig
paramNames = fieldnames(params);
paramNames = flipud(paramNames);
paramCount = length(paramNames);
h_fig = h * (paramCount + 3);  % 4 extra spots for buttons and menu
w_fig = w_fn + w_f + w_units + 10;
set(fig,'units','pixels','position',[1040 502 w_fig h_fig])

%% Init menus
m = uimenu(fig,'Label','&File');
uimenu(m,'Label','&Load Protocol...','Callback', {@readParams, module});
uimenu(m,'Label','&Save Protocol...','Callback', {@writeParams, module});
uimenu(m,'Label','&Close','Callback','closereq');

%% Generate controls
uicontrol(fig,'style','pushbutton','String','Close',...
          'position',[(w_fig - w_fn) / 2, x_pad, w_fn, h],...
          'Callback', 'closereq')

fn_ui = @paramChanged;
for i = 1:paramCount
    y       = y_pad + h * (i + 0.5);
    name    = paramNames{i};
    s       = params.(name);
    if ~strcmpi(s.fieldtype,'hidden')
        % The label for the parameter
        uicontrol(fig,'style','edit','String',s.description,...
                  'tooltipstring',name,...
                  'enable','inactive',...
                  'position',[x_pad, y, w_fn, h])
        p       = [w_fn + x_pad, y, w_f, h];
        % Its units, if it has any
        if isfield(s, 'units')
            p_u = [w_fn + w_f + x_pad + x_pad, y + 1, w_units, 18];
            uicontrol(fig,'position',p_u,'style','text',...
                  'String',s.units)
        end
        % If the value is not supplied by the calling function, attempt to
        % load the current value from control structure
        if ~isfield(s,'value')
            paramstruct = GetParam(module, name);
            s.value     = paramstruct.value;
        end
        % Add callback to custom field types ('file_in')
        if strcmpi(s.fieldtype, 'file_in')
            s.callback = @file_in_btn;
        end
        % Create the appropriate UI control
        switch lower(s.fieldtype)
        case {'string','value'}
            st = {'style','edit','BackgroundColor','white',...
                    'HorizontalAlignment','right'};
        case 'list'
            st = {'style','popupmenu','string',s.choices,'BackgroundColor','white'};
        case {'fixed','file_in','object'}
            st = {'style','edit','enable','inactive'};
            % create button if .callback is specified
            if isfield(s,'callback')
                p_u = [w_fn + w_f + x_pad + x_pad, y + 2, w_units/2, 18];
                cb = s.callback;
                uicontrol(fig,'position',p_u,'style','pushbutton',...
                    'String','',...
                    'Callback', {@callbackHandler module name})
            end
        end
        t = [module '.' name];
        u = uicontrol(fig,'position',p,st{:},'tag', t,...
            'callback',{fn_ui, module, name, s});
        setUIValue(u,s);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = setParams(module, struct)
% Updates the figure and control structure with values in <struct>. The UI
% objects must be tagged correctly, so PARAMFIGURE>NEWFIGURE must be called
% first.  If the figure does not exist, only the control values will be
% updated.

% Find the figure
fig     = FindFigure([module '.param']);

n = fieldnames(struct);
for i = 1:length(n)
    param   = n{i};
    s       = struct.(param);
    tag     = [module '.' param];
    h       = findobj(fig,'tag',tag);
    if ishandle(h)
        setUIValue(h, s)
    end
    SetParam(module, param, s)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [v] = getUIValue(obj, fieldtype)
% Retrieves the value from an uicontrol, translating list selections into
% the selected item, and value fields into numerics.
switch lower(fieldtype)
    case 'list'
        v = GetSelected(obj);
    case 'value'
        v = str2num(get(obj,'String'));
    otherwise
        v = get(obj,'String');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
function [v] = setUIValue(obj, struct)
% Sets the uicontrol to display the parameter value. This is done according
% to the parameter type. Note that objects fieldtypes return the string,
% which is passed to the object's constructor by SetParam
switch lower(struct.fieldtype)
    case 'list'
        set(obj, 'String', struct.choices);
        if ischar(struct.value)
            v = strmatch(struct.value, struct.choices);
        else
            v = struct.value;
        end
        if ~isempty(v)
            set(obj,'Value',v);
        else
            error('METAPHYS:valueOutOfRange',...
                'The option %s does not exist for parameter %s.',...
                struct.value, struct.name)
        end
    case 'object'
        v = char(struct.value)
        set(obj,'String',v,'tooltipstring',v);
    otherwise
        v = num2str(struct.value);
        set(obj,'String',v,'tooltipstring',v);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function paramstruct = removeFixed(paramstruct)
% removes 'fixed' fieldtypes from a param structure, which
% is necessary to avoid writing over fixed values that
% reflect some critical property of the hardware, etc
n = fieldnames(paramstruct);
for i = 1:length(n)
    p = paramstruct.(n{i});
    type = p.fieldtype;
    if strcmpi(type,'fixed')
        paramstruct = rmfield(paramstruct, n{i});
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = file_in_btn(obj, event, module, param)
% Function handle that's used for file_in fields.

% Find the field with the value in it (<obj> is the button)
obj     = findobj(gcbf, 'tag', param);
% Retrieve the default value 
default = get(obj,'tooltipstring');
[pn fn ext] = fileparts(default);
[fn2 pn2] = uigetfile([pn filesep '*.mat']);
if ~isnumeric(fn2)
    v = fullfile(pn2,fn2);
    set(obj,'string',fn2,'tooltipstring',v)
    SetParam(module, param, v);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = paramChanged(obj, event, module, param, paramstruct)
% This is the general callback function for all the editable fields in the
% parameter figure. It is called whenever a field is changed by the user,
% and updates the control structure, as well as calling any field-specific
% callbacks.

% Retrieve the value from the uicontrol
v = getUIValue(obj, paramstruct.fieldtype);
% Post it to the control structure
SetParam(module, param, v)
% Call field-specific callback. Note that this never gets called for
% file_in and fixed types, since the uicontrols are uneditable.
if isa(paramstruct.callback,'function_handle')
    paramstruct.callback(module, param, paramstruct);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = readParams(obj, event, module)
% Reads parameters from a matfile and sets the values in the figure and in
% control.
[fn pn] = uigetfile('*.mat');
if isnumeric(pn)
    return
end
pnfn = fullfile(pn,fn);
if exist(pnfn,'file')
    s = load(pnfn);
    s = removeFixed(s);
    setParams(module, s);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = writeParams(obj, event, module)
% Writes parameter values to a matfile, which can be opened using
% PARAMFIGURE>READPARAMS.
[fn pn] = uiputfile('*.mat');
if isnumeric(pn)
    return
end
pnfn = fullfile(pn,fn);
s = GetParam(module);
WriteStructure(pnfn,s);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = callbackHandler(obj, event, module, param)
% generally the custom callback on an param needs to be called with the
% actual value of the parameter, so this is a wrapper
S       = GetParam(module, param,'struct');
if iscell(S.callback)
    func    = S.callback{1};
    args    = {S.callback{2:end} S.value};
elseif isa(S.callback,'function_handle')
    func    = S.callback;
    args    = {S.value};
else
    return
end
S.value  = func(args{:});
paramstruct.(param) = S;
setParams(module, paramstruct);
