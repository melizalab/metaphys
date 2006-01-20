function [] = DeleteDAQ(daqnames)
%
% DELETEDAQ Deletes one or more daq objects from the control structure.
%
% Also calls the delete method on the daq objects, which causes them to be
% unloaded from active memory. Calls STOPDAQ. Recurses the instrument tree
% and deletes instruments that used this daq.
%
% DELETEDAQ(daqnames)
%
% DAQNAMES can be a single string or a cell array.
%
% See Also: INITDAQ, STOPDAQ
%
% $Id: DeleteDAQ.m,v 1.5 2006/01/21 01:22:23 meliza Exp $

global mpctrl

%% Stop the device
StopDAQ(daqnames)
daq     = GetDAQ(daqnames);

daqnames    = CellWrap(daqnames);
t   = sprintf(' %s', daqnames{:});
DebugPrint('Deactivating DAQ devices:%s.', t)

%% Delete the associated instrument channels
for i = 1:length(daqnames)
    instruments = GetInstrumentNames;
    for j = 1:length(instruments)
        chanstr = GetChannelStruct(instruments{j});
        if ~isempty(chanstr)
            parents = {chanstr.daq};
            channms = {chanstr.name};
            index   = strmatch(daqnames{i}, parents);
            for k = 1:length(index)
                DeleteChannel(instruments{j}, channms{k});
            end
        end
    end
end
        
%% Delete the DAQ and associated control structure
delete(daq)
mpctrl.daq = rmfield(mpctrl.daq, daqnames);
if length(fieldnames(mpctrl.daq)) == 0
    mpctrl.daq  = [];
end
