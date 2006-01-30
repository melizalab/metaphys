function [] = InitUIParam(module, tag, handle)
%
% INITUIPARAM Stores a handle in the control structure, which can be
% subsequently accessed with GETUIPARAM and SETUIPARAM. 
%
% Generally called by INITUIOBJECT or INITUICONTROL. If the tag already
% exists, the handle it refers to will be used to delete the corresponding
% object. This prevents multiple objects from existing with the same tag.
%
% [] = INITUIPARAM(module, tag, handle)
%
% module    - name of the module
% tag       - name of the object
% handle    - uiobject handle
%
% See also: INITUICONTROL, INITUIOBJECT
%
% $Id: InitUIParam.m,v 1.2 2006/01/30 20:04:58 meliza Exp $

global mpctrl

module  = lower(module);
tag     = lower(tag);

if isfield(mpctrl.(module).handles, tag)
    oldhandle   = mpctrl.(module).handles.(tag);
    if ishandle(oldhandle)
        delete(oldhandle)
    end
end

set(handle,'tag',tag);
mpctrl.(module).handles.(tag) = handle;
