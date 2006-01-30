function [] = SetDataStorage(mode, varargin)
%
% SETDATASTORAGE Sets where data will be stored
%
% By default, data is logged to memory, where it is retrieved by
% DATAHANDLER and passed to subscribing functions. The DAQ toolkit is also
% capable of storing acquisition data to disk as .daq files.  The data in
% these files can be recovered with the DAQREAD command. For most
% applications this is perfectly acceptable. However, there are two issues.
% The first is that instrument-centric information is lost. Channels will
% retain their names, so it is generally possible to determine what they
% refer to.  However, the second issue is that if more than one DAQ system
% is active, each system will record its data to disk separately, which can
% complicate recovery.
%
% As a result, it may be preferable to have DATAHANDLER write to disk. The
% advantage is that it will only write data from channels that are actually
% of experimental value (i.e. not telegraph channels or channels associated
% with other instruments). It can also store up an entire experiment and
% store it as a single matfile, removing the need to run DAQREAD on a whole
% directory full of data. However, because this data is initially stored in
% memory, if the system crashes during acquisition the data may be lost.
% The choice between these tradeoffs is left to the user.
%
% SETDATASTORAGE('memory') - stores data only in memory
%
% SETDATASTORAGE('daqfile') - stores data to disk using the DAQ toolkit's
%                             builtin methods
%
% SETDATASTORAGE('matfile',instrument) - 
%                             stores data to disk using the DATAHANDLER
%                       `     function and the MATWRITER subscriber
%
%
% $Id: SetDataStorage.m,v 1.6 2006/01/30 19:23:08 meliza Exp $

MATWRITER   = 'MatWriter';
mwfunc      = str2func(MATWRITER);

ainm = GetDAQNames('analoginput');
if isempty(ainm)
    return
end
ai   = GetDAQ(ainm);
data_dir    = GetUIParam('metaphys','data_dir');
data_prefix = GetDefaults('data_prefix');
newdir      = NextDataFile(data_dir, data_prefix);
mwfunc('flush');
switch lower(mode)
    case 'memory'
        set(ai, 'LoggingMode', 'Memory','LogFileName','0000.daq');
        DeleteSubscriber(MATWRITER)
    case 'daqfile'
        % daqfiles are collected in directories, one file per sweep and one
        % directory per start. This function gets called when a protocol is
        % started, so we need to figure out what the next directory is
        DeleteSubscriber(MATWRITER)
        if ~exist(fullfile(data_dir, newdir),'dir')
            mkdir(data_dir, newdir);
        end

        set(ai,...
                'LogToDiskMode', 'Index',...
                'LoggingMode', 'Disk&Memory');
        for i = 1:length(ainm)
            myfilename  = sprintf('%s-0000.daq', ainm{i});
            newfile = fullfile(data_dir, newdir, myfilename);
            set(ai(i), 'LogFileName', newfile)
        end
    case 'matfile'
        if nargin < 2
            error('METAPHYS:setdatastorage:insufficientArguments',...
                'Matfile logging requires that an instrument be specified.')
        end
            
        set(ai, 'LoggingMode', 'Memory');
        instrument  = varargin{1};
        sub         = GetSubscriber(MATWRITER);
        newfile     = fullfile(data_dir, newdir);
        if isempty(sub)
            sub     = subscriber_struct(MATWRITER, instrument,...
                mwfunc, {newfile});
        elseif isempty(strmatch(instrument, sub.instrument))
            sub.instrument  = {sub.instrument{:}, instrument};
        end
        AddSubscriber(sub)
        if ~exist(fullfile(data_dir, newdir),'dir')
            mkdir(data_dir, newdir);
        end
        % the LogFileName prop is important for matfile mode too
        for i = 1:length(ainm)
            myfilename  = sprintf('%s-0000.daq', ainm{i});
            newfile = fullfile(data_dir, newdir, myfilename);
            set(ai(i), 'LogFileName', newfile)
        end
end
% make data mode available; reset sweep counter
SetGlobal('data_mode', mode);
ResetSweepCounter