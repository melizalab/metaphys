function [] = DestroyControl()
%
% DESTROYCONTROL Performs a complete cleanup of the METAPHYS system. 
%
% All known DAQ objects are stopped and deleted; all known figures are
% deleted; and the mpctrl structure is cleared.
%
% See Also: INITCONTROL
%
% $Id: DestroyControl.m,v 1.1 2006/01/10 20:59:52 meliza Exp $
%
global mpctrl

DebugPrint('Beginning METAPHYS shutdown.');
%% Destroy DAQ devices
DebugPrint('Shutting down DAQ devices.')
daqnames    = GetDAQNames;
if ~isempty(daqnames)
    DeleteDAQ(daqnames)
end

%% Destroy Figures
DebugPrint('Deleting figures.')
modules     = GetModule;
for i = 1:length(modules)
    DeleteModule(modules{i});
end

%% Destroy control
mpctrl  = struct([]);

DebugPrint('METAPHYS shutdown complete.')