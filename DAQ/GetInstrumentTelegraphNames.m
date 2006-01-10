function names = GetInstrumentTelegraphNames(instrument)
%
% GETINSTRUMENTTELEGRAPHNAMES Returns the names of the telegraphs defined
% for an instrument.
%
% $Id: GetInstrumentTelegraphNames.m,v 1.1 2006/01/11 03:19:57 meliza Exp $

instr   = GetInstrument(instrument);
if isstruct(instr.telegraph)
    names   = fieldnames(instr.telegraph);
end