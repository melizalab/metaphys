function f  = getfunc(obj, param)
%
% GETFUNC Returns the function associated with a parameter
%
% GETFUNC(event, 'param') returns the 'param_func' function. If it does not
%                         exist, returns []
%
% $Id: getfunc.m,v 1.2 2006/01/26 23:37:35 meliza Exp $

fname   = sprintf('%s_func', param);
f       = get(obj, fname);
% if isfield(struct(obj), fname)
%     f   = obj.(fname);
% else
%     f   = [];
% end