function out = NextDataFile(path, prefix)
%
% NEXTDATAFILE Returns the next directory/filename for data storage.
%
% NEXTDATAFILE(path, prefix) looks in <path> to see what
% files/directories have already been stored that match the template (see
% below). It adds one to the serial number at the end of the template and
% returns that string to the caller.
%
%
% the filename returned will look like
% <prefix>_year_month_day-<serial>
%
% $Id: NextDataFile.m,v 1.2 2006/01/21 01:22:33 meliza Exp $

d = datevec(now);
files = dir(path);
n = {files.name};
basename = sprintf('%s_%i_%i_%i-',prefix, d(1:3));
files = strmatch(basename,n);
if isempty(files)
    out = sprintf('%s000',basename);
else
    files = sort(n(files));
    lastfile = files{length(files)};
    % extract the number at the end
    serial      = sscanf(lastfile, [basename '%d']);
    if isempty(serial)
        serial  = -1;
    end
    out     = sprintf('%s%03.0f', basename, serial+1);
end
    