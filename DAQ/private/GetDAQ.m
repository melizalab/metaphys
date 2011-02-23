function daq = GetDAQ(daqnames)
%
% GETDAQ Returns the DAQ objects referred to by their tags. 
%
% If multiple tags are supplied then an array of daq objects is returned.
% Checks for validity.
%
% daq = GETDAQ(daqnames)
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if nargin == 0 || isempty(daqnames)
    error('METAPHYS:invalidArguments',...
        '%s requires a character or cell array of daq names.', mfilename);
end

daqstr  = GetDAQStruct(daqnames);
daq     = [daqstr.obj];

