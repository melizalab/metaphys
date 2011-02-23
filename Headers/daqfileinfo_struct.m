function S = daqfileinfo_struct(varargin)
%
% DAQFILEINFO_STRUCT    Constructor for the daqfileinfo structure
%
% Fields:
%         .t_unit     -   the time unit
%         .t_rate     -   sampling rate (samples / t_unit)
%         .start_time -   the start time (serial date number)
%         .samples    -   the number of samples
%         .channel_names  the names of the channels
%         .channels   -   structure array of channel properties
%         .mode       -   index of mode telegraph channel (if there is one)
%         .gain       -   index of gain telegraph channel (if there is one)
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

fields  = {'t_unit', 't_rate', 'start_time', 'samples',...
           'channel_names', 'channels', 'mode', 'gain'};
C       = {'',[],[],[],[],[],[]};
req     = 5;

S   = StructConstruct(fields, C, req, varargin);