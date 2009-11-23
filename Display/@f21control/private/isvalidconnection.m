function out = isvalidconnection(connection)
%
% ISVALIDCONNECTION Returns boolean indicating whether a connection is valid
%
% $Id: isvalidconnection.m,v 1.1 2006/01/24 03:26:11 meliza Exp $
%

out = false;
if isa(connection, 'tcpip')
    status  = get(connection, 'Status');
    if ~strcmpi(status, 'closed')
        out = true;
    end
end
