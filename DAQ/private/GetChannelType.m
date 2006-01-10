function chantypes  = GetChannelType(channels)
%
% GETCHANNELTYPE Returns a cell array with channel types.
%
% GETCHANNELTYPE(channels) returns the types ('analog input, 'analog
% output') of the channels (which inherit from daqchild) supplied in the
% first argument. <channels> must be a single or array of daqchild objects.
%
% $Id: GetChannelType.m,v 1.1 2006/01/11 03:20:00 meliza Exp $

parents       = get(channels, 'Parent');
if iscell(parents)
    parents   = [parents{:}];
end
chantypes     = CellWrap(get(parents,'Type'));
