function out = isempty(obj)
%
% ISEMPTY   Returns true if the f21control object is not complete
%
% ISEMPTY(f21ctrl) returns true if the object is missing an essential
% field.
%
% $Id: isempty.m,v 1.1 2006/01/28 01:12:43 meliza Exp $

if isempty(obj.remote_host) || isempty(obj.remote_port)
    out = true;
else
    out = false;
end