function [props] = GetDefaults(class, defloc)
%
% GETDEFAULTS Retrieves default values for an object.
%
% Defaults are stored in three locations: in the Headers/ directory, 
% in the MATLAB preferences structure (accessed with GETPREF, SETPREF,
% etc), and in the .preferences field of the control structure.  The 
% defaults are applied in that order unless a specific location is 
% specified.  Call CLEARDEFAULTS to clear the non-file-based preferences.
%
% props = GETDEFAULTS(class, location)
%
% class  - the class of the object, which is basically a tag for where the
%          preferences are stored (e.g. class 'nidaqai' is stored in
%          Headers/ as nidaqai_default.m
% location - can be 'file', 'pref', or 'control'
%
% See Also: CLEARDEFAULTS, SETDEFAULTS, SETOBJECTDEFAULTS
%
% $Id: GetDefaults.m,v 1.3 2006/01/23 19:27:44 meliza Exp $

if nargin > 1
    switch lower(defloc)
        case 'file'
            props   = fromFile(class);
        case 'pref'
            props   = fromPrefs(class);
        case 'control'
            props   = fromControl(class);
        otherwise
            props   = [];
    end
else
    props   = fromControl(class);
    if isempty(props)
        props   = fromPrefs(class);
    end
    if isempty(props)
        props   = fromFile(class);
    end
end
    

function props = fromFile(class)
% Returns properties from a file, if it exists
filename = lower(sprintf('%s_%s', class, 'default'));
if exist(filename,'file')>0
    props     = feval(filename);
else
    props     = [];
end

function props = fromPrefs(class)
% Return properties from MATLAB preferences
GROUP   = 'METAPHYS';
if ispref(GROUP, class)
    props   = getpref(GROUP, class);
else
    props   = [];
end

function props = fromControl(class)
% Return properties from control structure
FIELD   = 'defaults';
global mpctrl
if isfield(mpctrl.(FIELD), class)
    props   = mpctrl.(FIELD).(class);
else
    props   = [];
end

