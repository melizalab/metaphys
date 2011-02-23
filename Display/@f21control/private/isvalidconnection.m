function out = isvalidconnection(connection)
%
% ISVALIDCONNECTION Returns boolean indicating whether a connection is valid
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE
%

out = false;
if isa(connection, 'tcpip')
    status  = get(connection, 'Status');
    if ~strcmpi(status, 'closed')
        out = true;
    end
end
