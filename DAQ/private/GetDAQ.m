function daq = GetDAQ(daqnames)
%
% GETDAQ Returns the DAQ objects referred to by their tags. 
%
% If multiple tags are supplied then an array of daq objects is returned.
% Checks for validity.
%
% daq = GETDAQ(daqnames)
%
% $Id: GetDAQ.m,v 1.1 2006/01/10 20:59:51 meliza Exp $

daqstr  = GetDAQStruct(daqnames);
daq     = [daqstr.obj];

