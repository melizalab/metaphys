function [] = SaveControl(filename)
%
% SAVECONTROL Writes fields from the control structure to a matfile for
% later retrieval. 
%
% Only data from the daq, instrument, and default fields is stored. The
% data in module fields depends on the handle values assigned by MATLAB
% during figure creation & are thus meaningless to future instantiations.
% Data which needs to be persistent must be stored under the defaults
% field.
%
% SAVECONTROL(filename): saves data in the file <filename>, which should
%                        have the extention '.mcr'
%
% See Also: LOADCONTROL, INITCONTROL
%
% $Id: SaveControl.m,v 1.2 2006/01/11 03:20:03 meliza Exp $

global mpctrl

%% Reduce structure to storable fields
savestruct  = struct('daq', mpctrl.daq,...
                     'instrument', mpctrl.instrument,...
                     'defaults', mpctrl.defaults);
WriteStructure(filename, savestruct)
DebugPrint('Wrote control structure to %s.', filename)