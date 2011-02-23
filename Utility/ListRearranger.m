function varargout = ListRearranger(varargin)
%
% LISTREARRANGER A callback handler used for moving items around in a
% listbox
%
% [string userdata] = LISTREARRANGER(handle, mode) Determines which items
% are selected in <handle>, and moves them up, down, or deletes them,
% depending on the value of <mode> ('up', 'down', or 'delete'). If return
% arguments are supplied, the values are not actually set on the object,
% but just returned to the caller.
%
% LISTREARRANGER(obj, event, handle, mode, @callback) - standard callback 
% signature. @callback(obj, event) is called after rearrangement
%
% The 'String' property of the list needs to be a cell array. If the
% 'UserData' property of the list is the same length as 'String', it will
% also be rearranged
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

% Parse the arguments
if nargin == 5
    obj     = varargin{1};
    event   = varargin{2};
    h       = varargin{3};
    mode    = varargin{4};
    cb      = varargin{5};
else
    h       = varargin{1};
    mode    = varargin{2};
    cb      = [];
    obj     = [];
    event   = [];
end

% Get the data from the object
type    = get(h,'style');
if ~strcmpi(type, 'listbox');
    error('METAPHYS:listrearranger:invalidObjectProperty',...
        'ListRearranger only works on list objects with cell arrays in String');
end

str     = get(h,'string');
if ~iscell(str)
    error('METAPHYS:listrearranger:invalidObjectProperty',...
        'ListRearranger only works on list objects with cell arrays in String');
end

ud      = get(h,'userdata');
sel     = get(h,'value');
ind     = 1:length(str);

% Do the rearrangement
switch mode
    case 'up'
        ind_start = sel(1) - 2;
        if ind_start == 0, ind_start = []; end
        newind      = ind(1:ind_start);
        newsel      = size(newind,2) + 1;

        newind      = [newind, sel];
        newind      = [newind setdiff(ind, newind)];
        newsel      = newsel:(newsel + length(mvs_sel) - 1);
    case 'down'        
        ind_end   = sel(end) + 2;
        if ind_end > ind(end), ind_end = []; end
        newind    = [sel, ind(ind_end:end)];
        newstart  = setdiff(sel, newind);
        newsel    = size(newstart,2) + 1;

        newind    = [newstart newind];
        newsel    = newsel:(newsel + length(mvs_sel) - 1);
    case {'delete','remove'}
        newind  = setdiff(ind, sel);
        newsel  = sel(1) - 1;
        if newsel < 1, newsel = 1; end
    otherwise
        error('METAPHYS:listrearranger:invalidMode',...
            'ListRearranger does not recognize operation %s', mode);
end

newstr    = str(newind);
if iscell(ud) && length(ud) == length(str)
    newud   = ud(newind);
else
    newud   = ud;
end

% Set the values
if nargout > 0
    varargout   = {newstr, newud};
else
    set(h,'string',newstr,'userdata',newud,'value',newsel);
end

% Make the callback
if ~isempty(cb)
    cb(obj, event);
end
