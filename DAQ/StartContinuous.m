function [] = StartContinuous(interval, loop, varargin)
%
% STARTCONTINUOUS Starts a continuous acquisition.
%
% STARTCONTINOUS(interval) - All known DAQ devices are started. Every
% <interval> ms, DATAHANDLER will be triggered to retrieve data.
%
% STARTCONTINOUS(interval, loop) - If there are any analogoutput objects
% active, their output will be repeated <loop> times. If <loop> is Inf, the
% queued data will repeat until the device is stopped (default).
%
% STARTCONTINOUS(interval, loop, userdata) - Writes contents of <userdata>
% to file, if the system is set to log to disk.  NOTE: if the data remains
% constant over multiple sweeps, use WRITEPROTOCOLDATA instead.
%
% Throws an error if any of the daq devices is running.
%
% See also: STOPDAQ, STARTSWEEP
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

% Get DAQ objects
daqnms  = GetDAQNames;
if isempty(daqnms)
    errordlg({'No digitizer devices have been activated.',...
             'Set up digitizer properties before starting protocols.'})
    return
end

daqs    = GetDAQ(daqnms);
if nargin < 2
    loop    = Inf;
end

% set acquisition times
types   = CellWrap(lower(daqs.Type));
for i = 1:size(types,1)
    switch types{i}
        case 'analog input'
            srate   = get(daqs(i), 'SampleRate');
            samp    = interval .* srate / 1000;
            set(daqs(i),...
                'SamplesPerTrigger', Inf,...
                'SamplesAcquiredFcnCount', samp,...
                'SamplesAcquiredFcn', @DataHandler);
        case 'analog output'
            set(daqs(i),'RepeatOutput',loop);
    end
end
StartDAQ(daqs, varargin{:});