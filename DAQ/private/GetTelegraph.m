function telestruct = GetTelegraph(instrument, telegraph)
%
% GETTELEGRAPH Returns the telgraph control structure for an instrument.
%
% $Id: GetTelegraph.m,v 1.1 2006/01/11 03:20:01 meliza Exp $

instr   = GetInstrumnt(instrument);

if ~isfield(instr.telegraph, telegraph)
    error('METAPHYS:daq:noSuchTelegraph',...
        'No such telegraph %s defined for instrument %s.',...
        telegraph, instrument)
end

telestruct  = instr.telegraph.(telegraph);