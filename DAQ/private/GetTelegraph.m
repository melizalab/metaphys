function telestruct = GetTelegraph(instrument, telegraph)
%
% GETTELEGRAPH Returns the telgraph control structure for an instrument.
%
% $Id: GetTelegraph.m,v 1.2 2006/01/14 00:48:14 meliza Exp $

instr   = GetInstrument(instrument);

if ~isfield(instr.telegraph, telegraph)
    error('METAPHYS:daq:noSuchTelegraph',...
        'No such telegraph %s defined for instrument %s.',...
        telegraph, instrument)
end

telestruct  = instr.telegraph.(telegraph);