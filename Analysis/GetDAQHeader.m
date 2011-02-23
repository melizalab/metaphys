function info = GetDAQHeader(filename)
% GETDAQHEADER  Retrieves header information from a daq file.
%
% info = GETDAQHEADER(filename)
%
% filename      -   The input file name
% info          -   The output daqfileinfo structure. Empty if the file
%                   does not exist or cannot be read by DAQREAD
%
% See also: DAQREAD, DAQFILEINFO_STRUCT
%
%   Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

T_UNIT  = 'ms';
T_FAC   = 1000;

info = [];
if nargin < 1 || isempty(filename) || ~ischar(filename)
    error('METAPHYS:invalidArgument',...
        '%s requires a single filename argument.', mfilename)
end
if ~exist(filename, 'file')
    warning('METAPHYS:fileNotFound',...
            '%s does not exist.', filename)
else
    try
        d = daqread(filename,'info');

        t_rate      = d.ObjInfo.SampleRate ./ T_FAC;
        start_time  = datenum(d.ObjInfo.InitialTriggerTime);
        samples     = d.ObjInfo.SamplesAcquired;
        channels    = d.ObjInfo.Channel;
        cnames      = {channels.ChannelName};
        mode        = strmatch('mode',cnames);
        gain        = strmatch('gain',cnames);

        info        = daqfileinfo_struct(T_UNIT, t_rate, start_time, ...
                                    samples, cnames, channels, mode, gain);
    catch
        info        = [];
    end
end
