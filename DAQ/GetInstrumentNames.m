function instruments = GetInstrumentNames()
%
% GETINSTRUMENTNAMES Returns a cell array containing a list of the initialized
% instruments stored in the control structure.
%
% instruments = GETINSTRUMENTNAMES()
%
% $Id: GetInstrumentNames.m,v 1.2 2006/01/11 03:19:57 meliza Exp $
global mpctrl

instruments = [];
if isfield(mpctrl, 'instrument')
    if isstruct(mpctrl.instrument)
        instruments     = fieldnames(mpctrl.instrument);
    end
end