function out = GetDAQPropInfo(daqname, property)
%
% GETDAQPROPINFO Retrieves property information from a DAQ object. 
%
% Uses the same syntax as DAQDEVICE/GETPROPINFO but with the string name
% for the DAQ object.
%
% out = GETDAQPROPINFO(daqname, 'Property')
% 
% See Also: PROPINFO
%
% $Id: GetDAQPropInfo.m,v 1.1 2006/01/10 20:59:50 meliza Exp $
%
daqobj  = GetDAQ(daqname);
out     = propinfo(daqobj, property);
