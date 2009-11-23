function C = getparameters(obj, fields)
%
% GETPARAMETERS Returns a cell array with one parameter to each element
%
% C = GETPARAMETERS(obj, fields)
%
% $Id: getparameters.m,v 1.1 2006/01/26 01:21:35 meliza Exp $

sf  = sprintf('obj.%s ', fields{:});
C   = eval(['{' sf '}']);