function channelstruct = channel_struct()
%
% CHANNEL_STRUCT Header for the channel structure in control
%
%           .obj    - the channel object
%           .name   - the channel name
%           .daq    - the name of the associated daq
%           .type   - 'input' or 'output'
%
% $Id: channel_struct.m,v 1.2 2006/01/12 02:02:04 meliza Exp $

channelstruct   = struct('obj',[],...
                         'name','',...
                         'daq','',...
                         'type','');