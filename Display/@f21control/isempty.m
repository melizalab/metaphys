function out = isempty(obj)
%
% ISEMPTY   Returns true if the f21control object is not complete
%
% ISEMPTY(f21ctrl) returns true if the object is missing an essential
% field.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if isempty(obj.remote_host) || isempty(obj.remote_port)
    out = true;
else
    out = false;
end