function out = get(obj, prop)
%
% GET Gets F21control object properties
%
% GET(f21ctrl, prop) - returns the property value of 'prop'
%
% GET() - Returns a structure with all property names and values
% 
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

out  = getallproperties(obj);

if nargin > 1
    out     = out.(prop);
end