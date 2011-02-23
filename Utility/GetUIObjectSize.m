function varargout = GetUIObjectSize(handle, units)
%
% GETUIOBJECTSIZE Computes the size of an object in a given set of units.
%
% Useful in building GUIs when you want to know how much room you have for
% other objects.
%
% pos   = GETUIOBJECTSIZE(handle, [units])
% [x y] = GETUIOBJECTSIZE(handle, [units])
%
% UNITS is, by default, the current setting of the 'Units' property of the
% object. If the user specifies a different value, the 'Units' property
% will be briefly changed and returned to its original value.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE
%

if nargin > 1
    oldunits    = get(handle, 'Units');
    set(handle,'Units',units)
    position    = get(handle, 'Position');
    set(handle,'Units',oldunits)
else
    position    = get(handle, 'Position');
end

if nargout == 2
    varargout = {position(3), position(4)};
else
    varargout = {position(3:4)};
end