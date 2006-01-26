function s = waveform_struct(varargin)
%
% WAVEFORM_STRUCT Returns a waveform structure
%
% A WAVEFORM is basically a collection of WAVEFORMEVENT objects. The
% collection is organized by channel, but the channels aren't named, for
% portability between instruments.
%
% Fields:
%   Required:
%       .channel_events = a cell array, each element of which is an array
%                         of waveformevent objects
%
% $Id: waveform_struct.m,v 1.1 2006/01/26 23:37:25 meliza Exp $

fields  = {'channel_names', 'channel_events'};
C       = {{},{}};
req     = 2;


s       = StructConstruct(fields, C, req, varargin);