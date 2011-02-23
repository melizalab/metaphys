function chantypes  = GetChannelType(channels)
%
% GETCHANNELTYPE Returns a channel's type.
%
% GETCHANNELTYPE(channels) returns the types ('output', 'input') of the
% channels (which inherit from daqchild) supplied in the first argument.
% <channels> must be a single daqchild object. Should only be used when the
% calling function does not have access to the name of the channel (as this
% will give access to the .type field in the channel structure)
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if ~isa(channels,'daqchild')
    error('METAPHYS:invalidArgument',...
        'Function operates on single daqchild objects.');
end
parents       = get(channels, 'Parent');

if length(parents) > 1
    error('METAPHYS:invalidArgument',...
        'Function cannot operate on multiple channels.');
end
chantypes     = get(parents,'Type');

%% Map to our channel types
switch lower(chantypes)
    case 'analog input'
        chantypes   = 'output';
    case 'analog output'
        chantypes   = 'input';
    case 'digital io'
        chantypes   = 'digital';
end
