function out = GetDAQPropInfo(daqname, property)
%
% GETDAQPROPINFO Retrieves property information from a DAQ object. 
%
% Uses the same syntax as DAQDEVICE/GETPROPINFO but with the string name
% for the DAQ object.
%
% out = GETDAQPROPINFO(daqname, 'Property')
% 
% See also: PROPINFO
%
% $Id: GetDAQPropInfo.m,v 1.2 2006/01/30 20:04:39 meliza Exp $
%
daqobj  = GetDAQ(daqname);
out     = propinfo(daqobj, property);
