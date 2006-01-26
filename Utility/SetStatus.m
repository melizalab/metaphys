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
% $Id: SetStatus.m,v 1.1 2006/01/26 23:37:29 meliza Exp $

try
    SetUIParam('metaphys','protocol_status',string)
catch
    DebugPrint(string)
end
