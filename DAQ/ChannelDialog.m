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
% $Id: ChannelDialog.m,v 1.5 2006/01/17 20:22:08 meliza Exp $

%% Open the figure
fig     = OpenGuideFigure(mfilename);

%% Populate the fields
        
SetUIParam(mfilename,'instrument_name',instrumentname);
switch lower(channel)
    case {'input' 'output'}
    otherwise
        channel = GetChannelStruct(instrumentname, channel);
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
if isstruct(channel)
    SetUIParam(mfilename,'type', channel.type)
    updateDigitizers
    SetUIParam(mfilename,'index', channel.obj.Index)
    SetUIParam(mfilename,'digitizer','Selected',channel.daq)
    switch channel.obj.Type
        case 'Channel'
            % store the old channel name in UserData
            SetUIParam(mfilename,'name','string',channel.name,...
                'UserData',channel.name)
            currentchan = channel.obj.HwChannel;
            SetUIParam(mfilename, mfilename, 'UserData', currentchan)
            updateChannels
            SetUIParam(mfilename,'hwchan','Selected',...
                       num2str(currentchan))
            SetUIParam(mfilename,'units','String',channel.obj.Units,...
                'Enable','On')
            gain    = GetChannelGain(channel.obj);
            SetUIParam(mfilename,'gain','String',...
                num2str(gain),'Enable','On')
%           NOTE: this code hasn't been tested yet because no one will call it            
%         case 'Line'
%             % store the old channel name in UserData
%             SetUIParam(mfilename,'name','string',channel.LineName,...
%                 'UserData',channel.LineName)
%             currentchan = channel.HwLine;
%             SetUIParam(mfilename, mfilename, 'UserData',currentchan)            
%             updateChannels
%             SetUIParam(mfilename,'hwchan','Selected',...
%                        num2str(currentchan))
%             SetUIParam(mfilename,'units','String',' ','Enable','Off')
%             SetUIParam(mfilename,'gain','String',' ','Enable','Off')
%             
        otherwise
            error('METAPHYS:noSuchChannelType',...
                'Unable to deal with channel type %s!', channel.Type)
    end
else
    % now we deal with the new channel situation
    SetUIParam(mfilename,'name','')
    SetUIParam(mfilename,'type',channel)
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
type       = GetUIParam(mfilename, 'type');
switch lower(type)
    case 'input'
        daqnames    = GetDAQNames('analogoutput');
    case 'output'
        daqnames    = GetDAQNames('analoginput');
    case 'digital'
        daqnames    = GetDAQNames('digitalio');
end

SetUIParam(mfilename,'digitizer','String', daqnames)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateChannels()
% Populates the channel selection popup
daqname     = GetUIParam(mfilename,'digitizer','Selected');
channels    = GetDAQHwChannels(daqname);
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
    case 'output'
        AddInstrumentOutput(chanstruct.instrument, chanstruct.daqname,...
            chanstruct.hwchan, chanstruct.name, 'Units', chanstruct.units);
    case 'input'
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
        elseif isnumeric(chan.name(1))
            errordlg('Channel names must begin with a letter!')
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
                DebugPrint('Transferred channel %s/%s from %s to %s.',...
                    chan.name, chan.instrument, olddaq.Name,...
                    chan.daqname);
            else
                SetInstrumentChannelProps(chan.instrument, chan.name,...
                    'HwChannel', chan.hwchan, 'Units', chan.units);
                SetChannelGain(chan.instrument, chan.name, chan.gain)
            end
            DebugPrint('Updated properties of channel %s/%s.',...
                chan.instrument, chan.name)
        end
        DeleteModule(mfilename)
end

