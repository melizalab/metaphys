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
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE
%
daqobj  = GetDAQ(daqname);
out     = propinfo(daqobj, property);
