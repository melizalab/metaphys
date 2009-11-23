function [] = sendcommand(obj, command, varargin)
%
% SENDCOMMAND Sends a command to the F21 connection
%
% SENDCOMMAND(f21ctrl, command, [command_arguments...])
%
% Does not return any response. Use this method for commands that do not
% generate feedback.
%
% $Id: sendcommand.m,v 1.1 2006/01/24 03:26:08 meliza Exp $

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
catch
    fclose(connection);
    delete(connection);
    rethrow(lasterror)
end

fclose(connection);
delete(connection);
