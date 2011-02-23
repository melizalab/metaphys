function s  = instrument_struct(varargin)
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
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

fields  = {'name', 'type', 'channels', 'telegraph'};
C       = {'', '', [], []};
req     = 1;

s   = StructConstruct(fields, C, req, varargin);
