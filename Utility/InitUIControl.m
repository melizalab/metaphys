function handle = InitUIControl(varargin)
% INITUICONTROL Creates an uicontrol and stores the handle in the 
% control structure.
%
% handle = INITUICONTROL(module, tag, [properties])
% handle = INITUICONTROL(parent, module, tag, [properties])
%
%   parent  - if a handle to the parent is supplied, the object will be
%             created as a child of that container, rather than the
%             module's figure
%   module  - the module name
%   tag     - the name used to refer to the object
%   properties - optional cell array used to set object properties
%                (e.g. {'color',[1 1 1],'doublebuffer','on',...})
%                or a comma-delimited list
%
%  See Also: INITUIPARAM
%
%   $Id: InitUIControl.m,v 1.1 2006/01/10 20:59:52 meliza Exp $

%% Parse the arguments and find the uicontrol parent
if ischar(varargin{1})
    module = varargin{1};
    tag    = varargin{2};
    nproparg   = 3;
    % Locate the module figure
    parent     = FindFigure(module);
    if ~ishandle(parent)
        error('METAPHYS:figureNotFound',...
            'No valid figure is associated with module %s', module)
    end
elseif ishandle(varargin{1})
    parent  = varargin{1};
    module  = varargin{2};
    tag     = varargin{3};
    nproparg    = 4;
else
    error('METAPHYS:argumentError',...
        'The first argument to INITUICONTROL must be a string or a handle')
end

%% Generate the uicontrol and apply properties
handle   = uicontrol(parent);
SetObjectDefaults(handle, 'uiparam');
if nargin >= nproparg
    set(handle, varargin{nproparg:nargin})
end

%% Store the handle
if ishandle(handle)
    InitUIParam(module, tag, handle);
end
