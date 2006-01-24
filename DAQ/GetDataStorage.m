function [mode] = GetDataStorage()
%
% GETDATASTORAGE Returns the current data storage mode
%
% [mode file] = GETDATASTORAGE
%
% Possible modes are 'memory', 'daqfile', and 'matfile'
% <file> is the directory or filename under which data will be stored
%
%
% $Id: GetDataStorage.m,v 1.2 2006/01/25 01:58:36 meliza Exp $

try
    mode    = GetParam('metaphys', 'data_mode');
catch
    file    = '';
end
    