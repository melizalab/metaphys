function [] = display(obj)
%
% DISPLAY Display method for F21CONTROL object.
%
% $Id: display.m,v 1.1 2006/01/24 03:26:06 meliza Exp $

fprintf('F21 Controller:\n\n');
fprintf('   Remote Host: %s:%d\n', obj.remote_host, obj.remote_port);

try
    remote_type    = get(obj, 'project_name');
    fprintf('   Remote Program: %s\n', remote_type);
catch
    fprintf('   Connection is invalid\n');
end
