function connection = openconnection(obj)
%
% OPENF21CONNECTION Returns a file handle that connects via tcp/ip to an
% f21 machine
%
% connection = OPENF21CONNECTION(obj)
%
%
% <connection> is a MATLAB tcpip object
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

% constant
INPUT_BUFFER_SIZE = 64000;

% open tcp/ip connection
connection = tcpip(obj.remote_host, obj.remote_port);

% enlarge buffer size
set(connection,'InputBufferSize',INPUT_BUFFER_SIZE);

% open 
try
    fopen(connection);
catch
    error('METAPHYS:f21control:invalidObject',...
        'Unable to connect to any controller at %s:%d',...
        obj.remote_host, obj.remote_port);
end
