function chantypes  = GetChannelType(channels)
%
% GETCHANNELTYPE Returns a channel's type.
%
% GETCHANNELTYPE(channels) returns the types ('analog input, 'analog
% output') of the channels (which inherit from daqchild) supplied in the
% first argument. <channels> must be a single or array of daqchild objects.
% If multiple daqchildren are supplied, a cell array is returned.
%
% $Id: GetChannelType.m,v 1.2 2006/01/11 23:04:00 meliza Exp $

parents       = get(channels, 'Parent');
if iscell(parents)
    parents   = [parents{:}];
end
chantypes     = get(parents,'Type');
