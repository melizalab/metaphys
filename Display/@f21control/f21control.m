function obj = f21control(remote_host, remote_port)
%
% F21CONTROL Constructs a F21CONTROL object (controller for another
% computer running f21)
%
% obj   = F21CONTROL('address',[port]) - Constructs an F21CONTROL object
% with a conneciton to the F21 program at <address>:<port> 
%
%
% The default port is 6543.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if nargin < 2
    remote_port    = 6543;
end

if nargin == 0
    obj     = struct('remote_host','',...
                     'remote_port',remote_port);
    obj = class(obj, 'f21control');
elseif isa(remote_host, 'f21control')
    obj = remote_host;
elseif ischar(remote_host) && isnumeric(remote_port)
    obj     = struct('remote_host',remote_host,...
                     'remote_port',remote_port);
    obj             = class(obj, 'f21control');
else
    error('METAPHYS:f21control:badConstructor',...
        'An invalid constructor was used for class %s', mfilename);
end