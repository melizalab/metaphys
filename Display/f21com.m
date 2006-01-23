function flog = f21com(remote_host,command,if_feedback,remote_port)
%
% F21COM Basic tool for sending and receiving data from remote f21.
%
% flog = F21COM(remote_host,command,if_feedback,remote_port);
%
% INPUTS remote_host    -  host name (ip)
%        command        -  command string
%        if_feedback    -  if get response (def. 0)
%        remote_port    -  port (def. 6543)
%
% OUTPUS flog
%
% Yuxi Fu, 7/18/2005
%
% $Id: f21com.m,v 1.1 2006/01/24 03:26:04 meliza Exp $

% constant
HEADER_SIZE = 8;
INPUT_BUFFER_SIZE = 64000;

% remote port
if nargin<4    
    remote_port = 6543; 
end
if nargin<3
    if_feedback = 0; 
end
flog.remote_host = remote_host;
flog.remote_port = remote_port;
flog.command = command;
flog.if_feedback = if_feedback;

% open tcp/ip connection
connection = tcpip(remote_host, remote_port);

% enlarge buffer size
set(connection,'InputBufferSize',INPUT_BUFFER_SIZE);

% open 
fopen(connection);

try
    % send commend
    fwrite(connection,command,'uint8');

    % feedback
    feedback = '';
    if if_feedback==1
        retval = 1;
        while(retval)
            header = fread(connection,HEADER_SIZE,'uint8');
            if isempty(header) 
                retval = 0; 
            end

            data_size = str2double(char(header'));
            if(data_size~=-1)
                data = fread(connection,data_size,'uint8');
                data_str = char(data');
                feedback = strcat(feedback,data_str);
            else
                retval = 0;
            end
        end
        flog.feedback = feedback;
    end

    if length(feedback)>0
        flog.feedback_ok = 1;
    else
        flog.feedback_ok = 0;
    end
catch
    % close connection
    fclose(connection);
    delete(connection);
    rethrow(lasterror)
end

% close connection
fclose(connection);
delete(connection);
clear connection

