function out = isvalid(obj)
%
% ISVALID Returns boolean indicating whether the object has a valid
% connection to an f21 program.
%
% bool = ISVALID(f21ctrl)
%
% $Id: isvalid.m,v 1.2 2006/01/24 21:42:17 meliza Exp $
%

out         = false;
connection  = [];
try
    connection  = openconnection(obj);
    if isa(connection, 'tcpip')
        status  = get(connection, 'Status');
        if ~strcmpi(status, 'closed')
            out = true;
        end
    end
    fclose(connection);
    delete(connection);
catch
    if ~isempty(connection)
        fclose(connection);
        delete(connection);
    end
end
