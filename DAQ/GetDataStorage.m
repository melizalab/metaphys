function [ddir mode] = GetDataStorage()
%
% GETDATASTORAGE Returns the current data storage directory
%
% [ddir file] = GETDATASTORAGE
%
% <ddir> is the directory under which data will be stored. Empty if no
% valid input daq devices can be found.
%
% Possible modes are 'memory', 'daqfile', and 'matfile'
%
%
% $Id: GetDataStorage.m,v 1.4 2006/01/30 19:23:07 meliza Exp $

ddir    = [];
mode    = GetGlobal('data_mode');

ainm = GetDAQNames('analoginput');
if isempty(ainm)
    return
end

% all daqs should be set to log to the same place
daq     = GetDAQ(ainm{1});
if ~isempty(daq) && isvalid(daq)
    logfile     = daq.LogFileName;
    ddir        = fileparts(logfile);
end
    