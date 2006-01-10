function [] = DeleteDAQ(daqnames)
%
% DELETEDAQ Deletes one or more daq objects from the control structure.
%
% Also calls the delete method on the daq objects, which causes them to be
% unloaded from active memory. Calls STOPDAQ.
%
% DELETEDAQ(daqnames)
%
% DAQNAMES can be a single string or a cell array.
%
% See Also: INITDAQ, STOPDAQ
%
% $Id: DeleteDAQ.m,v 1.2 2006/01/11 03:19:55 meliza Exp $

global mpctrl

StopDAQ(daqnames)
daq     = GetDAQ(daqnames);

if iscell(daqnames)
    t   = sprintf(' %s', daqnames{:});
    DebugPrint('Deactivating DAQ devices:%s.', t)
else
    DebugPrint('Deactivating DAQ device %s.', daqnames)
end

delete(daq)
mpctrl.daq = rmfield(mpctrl.daq, daqnames);
