function out = IsDAQProperty(daqname, propname)
%
% ISDAQPROPERTY Returns true if a daq object has a property.
%
% ISDAQPROPERTY(daqname, propname) Returns true if the daq object referred
% to by <daqname> has the property <propname>.
%
% See also: GETDAQPROPINFO, GETDAQNAMES
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

% This is a stupid workaround
daqprops  = GetDAQProperty(daqname);
out = isfield(daqprops, propname);