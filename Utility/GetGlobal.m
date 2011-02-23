function [out] = GetGlobal(fieldname)
%
% GETGLOBAL  Returns the value of a global variable in the control
% structure
%
% out = GETGLOBAL(fieldname)
%
% If the global variable has not been defined, returns []
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE
%
global mpctrl

if isfield(mpctrl.globals, fieldname)
    out = mpctrl.globals.(fieldname);
else
    out = [];
end