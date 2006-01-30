function out = IsDAQProperty(daqname, propname)
%
% ISDAQPROPERTY Returns true if a daq object has a property.
%
% ISDAQPROPERTY(daqname, propname) Returns true if the daq object referred
% to by <daqname> has the property <propname>.
%
% See also: GETDAQPROPINFO, GETDAQNAMES
%
% $Id: IsDAQProperty.m,v 1.2 2006/01/30 20:04:41 meliza Exp $

% This is a stupid workaround
daqprops  = GetDAQProperty(daqname);
out = isfield(daqprops, propname);