function out = isvalid(obj)
%
% ISVALID Returns boolean indicating whether the object has a valid
% connection to an f21 program.
%
% bool = ISVALID(f21ctrl)
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE
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
