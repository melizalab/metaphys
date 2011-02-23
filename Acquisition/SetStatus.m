function [] = SetStatus(string)
%
% SETSTATUS Updates the status field in the main display window
%
% SETSTATUS(S) puts the string S in the protocol status field of the main
% metaphys window. This is such a common action that this function exists
% for convenience. It also checks to make sure the object still exists,
% which is nice if things try to set the status while the system is being
% shut down
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

try
    SetUIParam('metaphys','protocol_status',string)
catch
    DebugPrint(string)
end
