function [mode file] = GetDataStorage()
%
% GETDATASTORAGE Returns the current data storage mode
%
% [mode file] = GETDATASTORAGE
%
% Possible modes are 'memory', 'daqfile', and 'matfile'
% <file> is the directory or filename under which data will be stored
%
%
% $Id: GetDataStorage.m,v 1.1 2006/01/25 01:31:35 meliza Exp $

try
    mode    = GetParam('metaphys', 'data_mode');
    if strcmpi(mode,'memory')
        file    = '';
    else
        file    = GetParam('metaphys','data_file');
    end
catch
    mode    = 'memory';
    file    = '';
end
    