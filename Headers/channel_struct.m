function channelstruct = channel_struct()
%
% CHANNEL_STRUCT Header for the channel structure in control
%
%           .obj    - the channel object
%           .name   - the channel name
%           .daq    - the name of the associated daq
%           .type   - 'analoginput' or 'analogoutput'
%
% $Id: channel_struct.m,v 1.1 2006/01/11 23:04:02 meliza Exp $

channelstruct   = struct('obj',[],...
                         'name','',...
                         'daq','',...
                         'type','');