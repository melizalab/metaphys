function names = GetInstrumentTelegraphNames(instrument)
%
% GETINSTRUMENTTELEGRAPHNAMES Returns the names of the telegraphs defined
% for an instrument.
%
% $Id: GetInstrumentTelegraphNames.m,v 1.2 2006/01/14 00:48:07 meliza Exp $

instr   = GetInstrument(instrument);
if isstruct(instr.telegraph)
    names   = fieldnames(instr.telegraph);
else
    names   = {};
end