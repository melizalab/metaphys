function [] = SetDataFileStatus(filename)
%
% SETDATAFILESTATUS Updates the data_file field in the main window.
%
%
% SETDATAFILESTATUS(S) - Puts the string S in the data_file field of the
% main window. Attempts to remove the bits of the filename that are already
% in data_dir.
%
% $Id: SetDataFileStatus.m,v 1.1 2006/01/30 19:23:04 meliza Exp $

MAIN    = 'metaphys';

if ~isempty(filename)
    data_dir    = GetUIParam(MAIN, 'data_dir');
    if ~isempty(strfind(filename, data_dir))
        dir_len     = length(data_dir) + 2;     % +1 for filesep
        filename    = filename(dir_len:end);
    end
end

SetUIParam(MAIN, 'data_file', filename);
