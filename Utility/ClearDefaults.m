function [] = ClearDefaults(class, defloc)
%
% CLEARDEFAULTS Clear default values for an object
% Default values can be stored in two locations:  
%
% In the MATLAB preferences structure (accessed with GETPREF, SETPREF,
% etc). These preferences are persistent between METAPHYS and MATLAB
% sessions.

% In the .preferences field of the control structure.  This structure is
% NOT persistent between sessions, but can be saved as a matfile. This
% matfile may be automatically or manually loaded. Preferences in this
% location have the highest priority.
%
%
% CLEARDEFAULTS(class, [location])
%
% class  - the class of the object, which is basically a tag for where the
%          preferences are stored.
% location - can be 'pref', or 'control'. If not supplied, both locations
%           will be cleared
%
% See Also: SETDEFAULTS, GETDEFAULTS
%
% $Id: ClearDefaults.m,v 1.1 2006/01/10 20:59:52 meliza Exp $

if nargin == 1
    clearPrefs(class)
    clearControl(class)
else
    switch lower(defloc)
        case 'pref'
            clearPrefs(class)
        case 'control'
            clearControl(class)
        otherwise
            error('METAPHYS:invalidArgument',...
                'Defaults can only be stored under ''pref'' or ''control''.');
    end
end

function [] = clearPrefs(class)
% Clear defaults from MATLAB preferences
GROUP   = 'METAPHYS';
if ispref(GROUP, class)
    rmpref(GROUP, class)
end

function [] = clearControl(class)
% Clear properties from control structure
global mpctrl
FIELD   = 'defaults';
if isfield(mpctrl.(FIELD), class)
    mpctrl.(FIELD) = rmfield(mpctrl.(FIELD), class);
end
