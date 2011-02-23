function f  = getfunc(obj, param)
%
% GETFUNC Returns the function associated with a parameter
%
% GETFUNC(event, 'param') returns the 'param_func' function. If it does not
%                         exist, returns []
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

fname   = sprintf('%s_func', param);
f       = get(obj, fname);
% if isfield(struct(obj), fname)
%     f   = obj.(fname);
% else
%     f   = [];
% end