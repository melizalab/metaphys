function [] = RenameInstrument(instrument, newname)
%
% RENAMEINSTRUMENT renames an instrument in the control structure.
%
% $Id: RenameInstrument.m,v 1.1 2006/01/14 00:48:10 meliza Exp $

global mpctrl

% Check for valid fieldname
if isempty(newname) | ~isnan(str2double(newname(1)))
    error('METAPHYS:instrument:invalidName',...
        'Instrument names must begin with a letter')
end

instr   = GetInstrument(instrument);
instr.name  = newname;

mpctrl.instrument.(newname) = instr;
mpctrl.instrument   = rmfield(mpctrl.instrument, instrument);