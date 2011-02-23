function names = GetInstrumentTelegraphNames(instrument)
%
% GETINSTRUMENTTELEGRAPHNAMES Returns the names of the telegraphs defined
% for an instrument.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

instr   = GetInstrument(instrument);
if isstruct(instr.telegraph)
    names   = fieldnames(instr.telegraph);
else
    names   = {};
end