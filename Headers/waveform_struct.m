function s = waveform_struct(varargin)
%
% WAVEFORM_STRUCT Returns a waveform structure
%
% A WAVEFORM is basically a collection of WAVEFORMEVENT objects. The
% collection is organized by channel.
%
% Fields:
%   Required:
%       .channel_name   = a cell array, each element of which is the name
%                         of a channel
%       .channel_events = a cell array, each element of which is an array
%                         of waveformevent objects
% 
% See Also: @WAVEFORM
%
% $Id: waveform_struct.m,v 1.3 2006/01/27 23:46:34 meliza Exp $

fields  = {'channel_names', 'channel_events'};
C       = {{},{}};
req     = 2;


s       = StructConstruct(fields, C, req, varargin);