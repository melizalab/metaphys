function channels   = GetDAQHwChannels(daqname)
%
% GETDAQHWCHANNELS Returns the available hardware channels on a daq
%
% GETDAQHWCHANNELS(daqname)
%
% Does not check to see what channels are in use, except for on digital io
% devices.
%
% See also: GETDAQ
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

daq         = GetDAQ(daqname);
switch lower(daq.Type)
    case 'analog input'
        daqmode     = get(daq,'InputType');
        switch lower(daqmode)
            case {'singleended','nonreferencedsingleended'}
                channels    = daqhwinfo(daq,'SingleEndedIDs');
            otherwise
                channels    = daqhwinfo(daq,'DifferentialIDs');
        end
    case 'analog output'
        channels    = daqhwinfo(daq,'ChannelIDs');
    case 'digital io'
        channels    = daqhwinfo(daq, 'TotalLines');
        channels    = 0:channels-1;
        used        = daq.Line.HwLine;
        if iscell(used)
            used    = [used{:}];
        end
        if ~isempty(used)
            channels    = setdiff(channels, used);
        end
end
