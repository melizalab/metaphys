function out = GetDAQRange(daqname)
%
% GETDAQRANGE Retrieves a list of the available voltage ranges for a device
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE
%
daqobj  = GetDAQ(daqname);
strt    = daqhwinfo(daqobj);
switch lower(strt.SubsystemType)
    case 'analoginput'
        out     = strt.InputRanges;
    case 'analogoutput'
        out     = strt.OutputRanges;
    otherwise
        out     = [];
end