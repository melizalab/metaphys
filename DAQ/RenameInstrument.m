function [] = RenameInstrument(instrument, newname)
%
% RENAMEINSTRUMENT renames an instrument in the control structure.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

global mpctrl

% Check for valid fieldname
if isempty(newname) || ~isnan(str2double(newname(1)))
    error('METAPHYS:instrument:invalidName',...
        'Instrument names must begin with a letter')
end

instr   = GetInstrument(instrument);
instr.name  = newname;

mpctrl.instrument.(newname) = instr;
mpctrl.instrument   = rmfield(mpctrl.instrument, instrument);