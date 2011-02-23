function [] = display(obj)
%
% DISPLAY Display method for F21CONTROL object.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

fprintf('F21 Controller:\n\n');
fprintf('   Remote Host: %s:%d\n', obj.remote_host, obj.remote_port);

try
    remote_type    = get(obj, 'project_name');
    fprintf('   Remote Program: %s\n', remote_type);
catch
    fprintf('   Connection is invalid\n');
end
