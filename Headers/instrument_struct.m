function s  = instrument_struct()
%
% INSTRUMENT_STRUCT Header for the instrument structure.

% Returns an empty structure with the correct fields for describing an
% instrument.
%
% Required fields:
%   type      - the type of the instrument (string)
%   channels  - an array of channels connected to the device's input/output
%
% $Id: instrument_struct.m,v 1.1 2006/01/10 20:59:51 meliza Exp $

s   = struct('type','',...
             'channels',[]);