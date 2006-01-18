function [] = InitInstrument(instrument, type)
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
% INITINSTRUMENT(instrumentstruct)
%
% name - any MATLAB-legal string; this will identify the instrument
% type - not implemented yet, used for supporting telegraphed instruments
% instrumentstruct - if supplied, this structure will be installed instead
%                    of the default empty structure. Also, in this case, if
%                    there is an instrument with the same name it will not
%                    actually be deleted (with DELETEINSTRUMENT), but
%                    simply replaced in the control structure. This is to
%                    avoid calling DELETE on any valid daqchild objects.
%
% See also INSTRUMENT_STRUCT
%
% $Id: InitInstrument.m,v 1.4 2006/01/19 03:14:55 meliza Exp $
global mpctrl

if isstruct(instrument)
    default     = instrument;
else
    default     = instrument_struct;
    if nargin > 1
        default.type    = type;
    end
    default.name    = lower(instrument);

    if isfield(mpctrl.instrument, default.name)
        DeleteInstrument(default.name)
    end
end

mpctrl.instrument.(default.name)     = default;
DebugPrint('Created instrument %s.', default.name);
