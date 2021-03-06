function [] = DestroyControl()
%
% DESTROYCONTROL Performs a complete cleanup of the METAPHYS system. 
%
% All known DAQ objects are stopped and deleted; all known figures are
% deleted; and the mpctrl structure is cleared.
%
% See also: INITCONTROL
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE
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
% it's best to do this recursively
modules     = flipud(GetModule);
for i = 1:length(modules)
    DeleteModule(modules{i});
end

%% Destroy control
mpctrl  = struct([]);

DebugPrint('METAPHYS shutdown complete.')