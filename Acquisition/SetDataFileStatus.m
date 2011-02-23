function [] = SetDataFileStatus(filename)
%
% SETDATAFILESTATUS Updates the data_file field in the main window.
%
% SETDATAFILESTATUS(S) - Puts the string S in the data_file field of the
% main window. Attempts to remove the bits of the filename that are already
% in data_dir.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

MAIN    = 'metaphys';

if ~isempty(filename)
    data_dir    = GetUIParam(MAIN, 'data_dir');
    if ~isempty(strfind(filename, data_dir))
        dir_len     = length(data_dir) + 2;     % +1 for filesep
        filename    = filename(dir_len:end);
    end
end

SetUIParam(MAIN, 'data_file', filename);
