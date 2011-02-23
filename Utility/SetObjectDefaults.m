function [] = SetObjectDefaults(object, class, location)
%
% SETOBJECTDEFAULTS Sets properties on an object (an uicontrol or a matlab
% class) to their default values.
%
% SETOBJECTDEFAULTS(object, class, [location]): Sets properties on OBJECT to the
% defaults stored as CLASS. If no defaults are stored under CLASS, the
% object is not touched. LOCATION can be 'file', 'prefs', or 'control'; if
% this is not supplied the defaults will be applied, in that order, from
% all three sources.
%
% object - the object whose preferences should be set. If this is an array,
%          the preferences will be applied to all the objects
%
% See also: GETDEFAULTS, SETDEFAULTS, CLEARDEFAULTS
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if nargin > 2
   props   = GetDefaults(class, location);
   if ~isempty(props)
       set(object, props);
   end
else
    pFile   = GetDefaults(class, 'file');
    pPref   = GetDefaults(class, 'prefs');
    pCont   = GetDefaults(class, 'control');
    if ~isempty(pFile)
        set(object, pFile);
    end
    if ~isempty(pPref)
        set(object, pPref);
    end
    if ~isempty(pCont)
        set(object, pCont);
    end
end
