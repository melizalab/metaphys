function output = sendrequest(obj, command, varargin)
%
% SENDREQUEST Sends a command to the F21 connection and returns a response.
%
% output = SENDREQUEST(f21ctrl, command, [command_arguments...])
%
% IMPORTANT: do not call this method if the command doesn't return feedback
% or it will hang temporarily.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

HEADER_SIZE = 8;
MODE = 'uint8';

connection  = openconnection(obj);

% generate the command
if nargin > 2
    for i = 1:length(varargin)
        if ischar(varargin{i})
            command = sprintf('%s,%s', command, varargin{i});
        elseif isnumeric(varargin{i})
            command = sprintf('%s,%d', command, varargin{i});
        end
    end
end

try
    if isvalidconnection(connection)
        fwrite(connection,command,MODE);
    else
        error('METAPHYS:f21control:invalidObject',...
            'Attempted to send a command to an invalid connection.')
    end

    output = '';
    retval = 1;
    while(retval)
        header = fread(connection,HEADER_SIZE,MODE);
        if isempty(header), retval = 0; end

        data_size = str2double(char(header'));
        if(data_size~=-1)
            data        = fread(connection,data_size,MODE);
            data_str    = char(data');
            output      = strcat(output,data_str);
        else
            retval = 0;
        end
    end
catch
    fclose(connection)
    delete(connection)
    rethrow(lasterror)
end


fclose(connection)
delete(connection)

