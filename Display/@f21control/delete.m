function [] = delete(obj)
%
% DELETE closes and deletes an F21CONTROL object
%
% DELETE(obj)
%
% $Id: delete.m,v 1.1 2006/01/24 03:26:05 meliza Exp $

if nargin == 1 && isa(obj, 'f21control')
    % this would do something if we had any open connections
end
