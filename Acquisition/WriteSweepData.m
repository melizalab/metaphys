function [] = WriteSweepData(data)
%
% WRITESWEEPDATA    Writes data associated with a particular sweep to disk
%
% WRITESWEEPDATA(data): If the DAQ system is currently logging data to
% disk, this command will write a the contents of the <data> structure to
% the current data directory. The filename is '<sweepnum>-data.mat'. If the
% system is not currently logging to disk, no action is taken.
%
% See also: WRITEPROTOCOLDATA
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

data_mode   = GetGlobal('data_mode');
BASENAME    = '%04.0f-data.mat';

if nargin > 0 && ~strcmpi(data_mode, 'memory') && isstruct(data)
    sweepnum    = GetSweepCounter;
    ddir        = GetDataStorage;
    if ~isempty(ddir)
        pnfn        = fullfile(ddir, sprintf(BASENAME, sweepnum));
        WriteStructure(pnfn, data)
    end
end
        
    
