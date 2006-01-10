function out = IsDAQProperty(daqname, propname)
%
% ISDAQPROPERTY Returns true if a daq object has a property.
%
% ISDAQPROPERTY(daqname, propname) Returns true if the daq object referred
% to by <daqname> has the property <propname>.
%
% See Also: GETDAQPROPINFO, GETDAQNAMES
%
% $Id: IsDAQProperty.m,v 1.1 2006/01/10 20:59:50 meliza Exp $

% This is a stupid workaround
daqprops  = GetDAQProperty(daqname);
out = isfield(daqprops, propname);