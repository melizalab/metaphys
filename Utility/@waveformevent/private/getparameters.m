function C = getparameters(obj, fields)
%
% GETPARAMETERS Returns a cell array with one parameter to each element
%
% C = GETPARAMETERS(obj, fields)
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

sf  = sprintf('obj.%s ', fields{:});
C   = eval(['{' sf '}']);