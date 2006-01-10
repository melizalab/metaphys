function daqs   = GetDAQNames()
%
% GETDAQNAMES Returns a cell array containing a list of the initialized
% daq objects stored in the control structure.
%
% daqs = GETDAQNAMES()
%
% $Id: GetDAQNames.m,v 1.1 2006/01/10 20:59:50 meliza Exp $
global mpctrl

if isempty(mpctrl.daq)
    daqs    = [];
else
    daqs    = fieldnames(mpctrl.daq);
end