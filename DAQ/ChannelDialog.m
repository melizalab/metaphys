function [] = ChannelDialog(instrumentname, channel)
%
% CHANNELDIALOG Dialogue box for configuring instrument channels.
%
% The channels referred to here are virtual devices that refer to real
% channel on real DAQ hardware, but are associated with a particular
% instrument. This is a simple dialog box that lets the user specify some
% properties of the channel. Note that the channel is not created or
% modified until the user clicks 'OK'
%
%
% CHANNELDIALOG(instrumentname, channeltype) creates a new channel
% (<channeltype> can be 'input' or 'output')
%
% CHANNELDIALOG(instrumentname, channelname) edits an existing channel
%
% 
%
% See Also: ADDINSTRUMENTINPUT, ADDINSTRUMENTOUTPUT
%
% $Id: ChannelDialog.m,v 1.2 2006/01/11 23:03:55 meliza Exp $

%% Open the figure
fig     = OpenGuideFigure(mfilename);

%% Populate the fields
        
SetUIParam(mfilename,'instrument_name',instrumentname);
switch lower(channel)
    case {'input' 'output'}
    otherwise
        channel = GetInstrumentChannel(instrumentname, channel);
end
updateFigure(channel)

%% Set callbacks
setCallbacks

set(fig,'WindowStyle','modal')
uiwait(fig)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = setCallbacks()
objects = {'digitizer','btn_ok','btn_cancel'};
for i = 1:length(objects)
    SetUIParam(mfilename,objects{i},'Callback',@buttonHandler);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateFigure(channel)
% Updates values in the figure based on channel data. This is a little
% tricky because channel may be an object or a string
if isobject(channel)
    SetUIParam(mfilename,'type',GetChannelType(channel))
    updateDigitizers
    SetUIParam(mfilename,'index', channel.Index)
    parent  = channel.Parent;
    SetUIParam(mfilename,'digitizer','Selected',parent.Name)
    switch channel.Type
        case 'Channel'
            % store the old channel name in UserData
            SetUIParam(mfilename,'name','string',channel.ChannelName,...
                'UserData',channel.ChannelName)
            currentchan = channel.HwChannel;
            SetUIParam(mfilename, mfilename, 'UserData',currentchan)
            updateChannels
            SetUIParam(mfilename,'hwchan','Selected',...
                       num2str(currentchan))
            SetUIParam(mfilename,'units','String',channel.Units,...
                'Enable','On')
            gain    = GetChannelGain(channel);
            SetUIParam(mfilename,'gain','String',...
                num2str(gain),'Enable','On')
        case 'Line'
            % store the old channel name in UserData
            SetUIParam(mfilename,'name','string',channel.LineName,...
                'UserData',channel.LineName)
            currentchan = channel.HwLine;
            SetUIParam(mfilename, mfilename, 'UserData',currentchan)            
            updateChannels
            SetUIParam(mfilename,'hwchan','Selected',...
                       num2str(currentchan))
            SetUIParam(mfilename,'units','String',' ','Enable','Off')
            SetUIParam(mfilename,'gain','String',' ','Enable','Off')
        otherwise
            error('METAPHYS:noSuchChannelType',...
                'Unable to deal with channel type %s!', channel.Type)
    end
else
    % now we deal with the new channel situation
    SetUIParam(mfilename,'name','')
    switch lower(channel)
        case 'input'
            SetUIParam(mfilename,'type','Analog Output')
        case 'output'
            SetUIParam(mfilename,'type','Analog Input')
        otherwise
            error('METAPHYS:noSuchChannelType',...
                'Unable to deal with channel type %s!', channel)
    end
    updateDigitizers
    SetUIParam(mfilename,'index','')
    SetUIParam(mfilename,'units','String','','Enable','On')
    SetUIParam(mfilename,'gain','String','','Enable','On')
    updateChannels
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateDigitizers()
% Only certain kinds of channels, of course, are allowed to be inputs or
% outputs.
types       = GetUIParam(mfilename, 'type');
daqnames    = GetDAQNames(types);

SetUIParam(mfilename,'digitizer','String', daqnames)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateChannels()
% Populates the channel selection popup
daqname     = GetUIParam(mfilename,'digitizer','Selected');
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
%         used        = daq.Channel.HwChannel;
%         if iscell(used)
%             used        = [used{:}];
%         end
%         if ~isempty(used)
%             channels    = setdiff(channels, used);
%         end
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
currentchannel  = GetUIParam(mfilename,mfilename,'UserData');
if ~isempty(currentchannel)
    channels    = union(channels, currentchannel);
end
SetUIParam(mfilename,'hwchan','String',...
    cellstr(strjust(num2str(channels'),'left')));
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s  = getData()
% Returns a structure with all the data in the figure
s   = struct('instrument',GetUIParam(mfilename,'instrument_name'),...
    'type',GetUIParam(mfilename,'type'),...
    'index',GetUIParam(mfilename,'index'),...
    'name',GetUIParam(mfilename,'name'),...
    'oldname',GetUIParam(mfilename,'name','UserData'),...
    'daqname',GetUIParam(mfilename,'digitizer','selected'),...
    'hwchan',str2double(GetUIParam(mfilename,'hwchan','selected')),...
    'units',GetUIParam(mfilename,'units'),...
    'gain',GetUIParam(mfilename,'gain','stringval'));
% set some values if they're missing
if isempty(s.gain)
    s.gain  = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = makeNewChannel(chanstruct)
% Create new channel
switch lower(chanstruct.type)
    case 'analog input'
        AddInstrumentOutput(chanstruct.instrument, chanstruct.daqname,...
            chanstruct.hwchan, chanstruct.name, 'Units', chanstruct.units);
    case 'analog output'
        AddInstrumentInput(chanstruct.instrument, chanstruct.daqname,...
            chanstruct.hwchan, chanstruct.name, 'Units', chanstruct.units);
    otherwise
        error('MATLAB:unsupportedOperation',...
            'No function exists to add %s channels', chanstruct.type)
end
SetChannelGain(chanstruct.instrument, chanstruct.name,...
    chanstruct.gain)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = buttonHandler(obj, event)
tag = get(obj,'tag');
switch tag
    case 'digitizer'
        updateChannels
    case 'btn_cancel'
        DeleteModule(mfilename)
    case 'btn_ok'
        chan    = getData;
        if isempty(chan.name)
            errordlg('The channel must have a name!')
            return
        end
        
        if isempty(chan.index)
            makeNewChannel(chan)
        else
            % update existing channel.
            % rename the channel if needed
            if ~strcmpi(chan.name, chan.oldname)
                RenameInstrumentChannel(chan.instrument, chan.oldname,...
                                        chan.name);
            end
            % check to see if the user changed daqs
            olddaq      = GetInstrumentChannelProps(chan.instrument,...
                                                 chan.name,'parent');
            if ~strcmpi(chan.daqname, olddaq.Name)
                DeleteInstrumentChannel(chan.instrument, chan.name)
                makeNewChannel(chan)
            else
                SetInstrumentChannelProps(chan.instrument, chan.name,...
                    'HwChannel', chan.hwchan, 'Units', chan.units);
            end
        end
        DeleteModule(mfilename)
end
    
