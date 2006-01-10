function out = GetDAQProperty(daqname, varargin)
%
% GETDAQPROPERTY Retrieves property value(s) from a DAQ object. 
%
% Uses the same syntax as DAQDEVICE/GET but with the string name for the
% DAQ object.
%
% out = GETDAQPROPERTY(daqname, ['Property'])
% 
% If Property is replaced by a 1-by-N or N-by-1 cell array of strings 
% containing property names, then GETDAQPROPERTY will return a 1-by-N cell 
% array of values.  If DAQNAME is a cell array of daq names, then the
% output will be a M-by-N cell array of property values where M is equal 
% to the length of OBJ and N is equal to the number of properties specified.
%
% If Property is omitted, all the properties of the object will be
% returned in a structure.
%
% $Id: GetDAQProperty.m,v 1.1 2006/01/10 20:59:50 meliza Exp $
%
daqobj  = GetDAQ(daqname);
out     = get(daqobj, varargin{:});
