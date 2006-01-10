function channames   = GetInstrumentChannelNames(instrument)
%
% GETINSTRUMENTCHANNELNAMES Returns a cell array containing a list of all
% the defined instrument channels for a given instrument.
%
% GETINSTRUMENTCHANNEL(instrumentname)
%
% See Also: GETINSTRUMENTNAMES, INITINSTRUMENT
%
% $Id: GetInstrumentChannelNames.m,v 1.1 2006/01/10 20:59:50 meliza Exp $

global mpctrl

if ~isfield(mpctrl.instrument, instrument)
    error('METAPHYS:daq:noSuchInstrument',...
        'No such instrument %s has been defined.', instrument)
end

channames = fieldnames(mpctrl.instrument.(instrument).channels);