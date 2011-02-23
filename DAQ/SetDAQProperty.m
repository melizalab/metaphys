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
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE
%
daqobj  = GetDAQ(daqname);
if nargin > 2
    set(daqobj, varargin{:})
else
    out     = set(daqobj, varargin{:});
end
