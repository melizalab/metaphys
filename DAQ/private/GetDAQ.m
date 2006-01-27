function daq = GetDAQ(daqnames)
%
% GETDAQ Returns the DAQ objects referred to by their tags. 
%
% If multiple tags are supplied then an array of daq objects is returned.
% Checks for validity.
%
% daq = GETDAQ(daqnames)
%
% $Id: GetDAQ.m,v 1.2 2006/01/28 00:46:12 meliza Exp $

if nargin == 0 || isempty(daqnames)
    error('METAPHYS:invalidArguments',...
        '%s requires a character or cell array of daq names.', mfilename);
end

daqstr  = GetDAQStruct(daqnames);
daq     = [daqstr.obj];

