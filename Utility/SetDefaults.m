function [] = SetDefaults(class, defloc, props)
%
% SETDEFAULTS Set default values for an object.
%
% Default values can be stored in two locations:  
%
% * In the MATLAB preferences structure (accessed with GETPREF, SETPREF,
%   etc). These preferences are persistent between METAPHYS and MATLAB
%   sessions.
%
% * In the .preferences field of the control structure.  This structure is
%   NOT persistent between sessions, but can be saved as a matfile. This
%   matfile may be automatically or manually loaded. Preferences in this
%   location have the highest priority.
%
%
% SETDEFAULTS(class, location, props)
%
% class  - the class of the object, which is basically a tag for where the
%          preferences are stored.
% location - can be 'pref', or 'control'
% props  - a structure array with fields corresponding to the properties of
%          the object
%
% See also: CLEARDEFAULTS, GETDEFAULTS
%
% $Id: SetDefaults.m,v 1.2 2006/01/30 20:05:00 meliza Exp $

switch lower(defloc)
    case 'pref'
        toPrefs(class, props)
    case 'control'
        toControl(class, props)
    otherwise
        error('METAPHYS:invalidArgument',...
            'Defaults can only be stored under ''pref'' or ''control''.');
end

function [] = toPrefs(class, props)
% Store properties to MATLAB preferences
GROUP   = 'METAPHYS';
setpref(GROUP, class, props)

function [] = toControl(class, props)
% Store properties to control structure
global mpctrl
FIELD   = 'defaults';
mpctrl.(FIELD).(class) = props;
