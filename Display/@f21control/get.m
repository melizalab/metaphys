function out = get(obj, prop)
%
% GET Gets F21control object properties
%
% GET(f21ctrl, prop) - returns the property value of 'prop'
%
% GET() - Returns a structure with all property names and values
% 
%
% $Id: get.m,v 1.1 2006/01/24 03:26:06 meliza Exp $

out  = getallproperties(obj);

if nargin > 1
    out     = out.(prop);
end