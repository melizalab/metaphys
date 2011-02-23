function telestruct = GetTelegraph(instrument, telegraph)
%
% GETTELEGRAPH Returns the telgraph control structure for an instrument.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

instr   = GetInstrument(instrument);

if ~isfield(instr.telegraph, telegraph)
    error('METAPHYS:daq:noSuchTelegraph',...
        'No such telegraph %s defined for instrument %s.',...
        telegraph, instrument)
end

telestruct  = instr.telegraph.(telegraph);