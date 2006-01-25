function [out] = GetGlobal(fieldname)
%
% GETGLOBAL  Returns the value of a global variable in the control
% structure
%
% out = GETGLOBAL(fieldname)
%
% If the global variable has not been defined, returns []
%
% $Id: GetGlobal.m,v 1.1 2006/01/25 17:49:32 meliza Exp $
%
global mpctrl

if isfield(mpctrl.globals, fieldname)
    out = mpctrl.globals.(fieldname);
else
    out = [];
end