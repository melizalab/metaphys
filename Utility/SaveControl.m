function [] = SaveControl(filename, subsystem)
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
% SAVECONTROL(filename, subsystem): Only saves the subsystem specified by
%                                   the <subsystem> argument. This can be
%                                   'daq','instrument',or 'defaults'
%
% See Also: LOADCONTROL, INITCONTROL
%
% $Id: SaveControl.m,v 1.4 2006/01/27 23:46:43 meliza Exp $

global mpctrl

if nargin < 1 || isempty(filename)
    error('METAPHYS:invalidArguments',...
        '%s requires a non-empty filename argument.', mfilename);
end

if nargin == 1
    subsystem = {'daq', 'instrument', 'defaults'};
end

%% Reduce structure to storable fields
savestruct  = GetFields(mpctrl, subsystem);

WriteStructure(filename, savestruct)
DebugPrint('Wrote control structure to %s.', filename)