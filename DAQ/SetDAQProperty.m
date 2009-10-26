function [out] = SetDAQProperty(daqname, varargin)
%
% SETDAQPROPERTY Sets property value(s) on a DAQ object. 
%
% Uses the same syntax as DAQDEVICE/SET but with the string name for the
% DAQ object.
%
% SETDAQPROPERTY(daqname, ['Property'])
% 
% See also DAQDEVICE/SET
%
% $Id: SetDAQProperty.m,v 1.1.1.1 2006/01/10 20:59:50 meliza Exp $
%
daqobj  = GetDAQ(daqname);
if nargin > 2
    set(daqobj, varargin{:})
else
    out     = set(daqobj, varargin{:});
end
