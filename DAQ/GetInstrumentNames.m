function instruments = GetInstrumentNames()
%
% GETINSTRUMENTNAMES Returns a cell array containing a list of the initialized
% instruments stored in the control structure.
%
% instruments = GETINSTRUMENTNAMES()
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE
global mpctrl

instruments = [];
if isfield(mpctrl, 'instrument')
    if isstruct(mpctrl.instrument)
        instruments     = fieldnames(mpctrl.instrument);
    end
end