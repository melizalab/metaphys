function channelstruct = channel_struct(varargin)
%
% CHANNEL_STRUCT Header for the channel structure in control
%
%           .obj    - the channel object
%           .name   - the channel name
%           .daq    - the name of the associated daq
%           .type   - 'input' or 'output'
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

fields  = {'obj', 'name', 'daq', 'type'};
C       = {[], '', '', ''};
req     = 4;

channelstruct = StructConstruct(fields, C, req, varargin);
