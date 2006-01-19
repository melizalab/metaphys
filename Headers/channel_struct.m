function channelstruct = channel_struct(varargin)
%
% CHANNEL_STRUCT Header for the channel structure in control
%
%           .obj    - the channel object
%           .name   - the channel name
%           .daq    - the name of the associated daq
%           .type   - 'input' or 'output'
%
% $Id: channel_struct.m,v 1.3 2006/01/20 02:03:13 meliza Exp $

fields  = {'obj', 'name', 'daq', 'type'};
C       = {[], '', '', ''};
req     = 4;

channelstruct = StructConstruct(fields, C, req, varargin);
