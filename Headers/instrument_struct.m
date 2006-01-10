function s  = instrument_struct()
%
% INSTRUMENT_STRUCT Header for the instrument structure.

% Returns an empty structure with the correct fields for describing an
% instrument.
%
% Required fields:
%   name      - the name of the instrument (string)
%   type      - the type of the instrument (string)
%   channels  - an array of channels connected to the device's input/output
%   telegraph - a structure array defining the device's telegraphs
%
% $Id: instrument_struct.m,v 1.2 2006/01/11 03:20:02 meliza Exp $

s   = struct('name','',...
             'type','',...
             'channels',[],...
             'telegraph',struct([]));