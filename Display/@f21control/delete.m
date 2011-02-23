function [] = delete(obj)
%
% DELETE closes and deletes an F21CONTROL object
%
% DELETE(obj)
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if nargin == 1 && isa(obj, 'f21control')
    % this would do something if we had any open connections
end
