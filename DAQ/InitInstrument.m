function [] = InitInstrument(name, type)
%
% INITINSTRUMENT Initializes an instrument in the control structure.
%
% Instruments are virtual objects composed of a combination of input and
% output channels. In some cases there may be special means of
% communicating with the instrument (for instance, using the MultiClamp
% Commander for Multiclamp 700A and 700B instruments); these cases are
% handled by special drivers.  There are also telegraph channels which have
% a special behavior in that they control how the other outputs of the
% instrument should be interpreted.  This function adds an instrument to
% the control structure with no inputs or outputs. If an instrument with
% the same name already exists it is first deleted.
%
% INITINSTRUMENT(name, [type])
%
% name - any MATLAB-legal string; this will identify the instrument
% type - not implemented yet, used for supporting telegraphed instruments
%
% See also INSTRUMENT_STRUCT
%
% $Id: InitInstrument.m,v 1.2 2006/01/11 03:19:57 meliza Exp $
global mpctrl

name    = lower(name);

default = instrument_struct;
if nargin > 1
    default.type    = type;
end
default.name    = name;

if isfield(mpctrl.instrument, name)
    DeleteInstrument(name)
end

mpctrl.instrument.(name)     = default;
DebugPrint('Created instrument %s.', name);
