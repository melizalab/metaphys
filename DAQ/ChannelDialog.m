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
% $Id: ChannelDialog.m,v 1.1 2006/01/11 03:19:54 meliza Exp $

%% Open the figure
fig     = OpenGuideFigure(mfilename);

%% Populate the fields
        
SetUIParam(mfilename,'instrument_name',instrumentname);
updateFigure(channel)

%% Set callbacks
setCallbacks

set(fig,'WindowStyle','modal')
uiwait(fig)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function channel = newChannel(type)
% % creates a structure that can be used in generating a new channel
% channel = GetDefaults('channel');
% channel.Name    = sprintf('new_%s',type);
% switch type
%     case 'input'
%         channel.Type    = 'Analog Output';
%     case 'output'
%         channel.Type    = '

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
    SetUIParam(mfilename,'name',channel.ChannelName)
    SetUIParam(mfilename,'type',GetChannelType(channel))
    updateDigitizers
    SetUIParam(mfilename,'index', channel.Index)
    SetUIParam(mfilename,'digitizer','Selected',channel.Parent.Name)
    switch channel.Type
        case 'Channel'
            currentchan = channel.HwChannel;
            SetUIParam(mfilename, mfilename, 'UserData',currentchan)
            updateChannels
            SetUIParam(mfilename,'hwchan','Selected',...
                       num2str(currentchan))
            SetUIParam(mfilename,'units',channel.Units,...
                'Enable','On')
            switch lower(type)
                case 'analog input'
                    % this only really works if the range is symmetric
                    gain    = channel.UnitsRange ./ channel.SensorRange;
                    gain    = gain(1);
                case 'analog output'
                    gain    = channel.UnitsRange ./ channel.OutputRange;
                    gain    = gain(1);
                otherwise
                    error('METAPHYS:noSuchChannelType',...
                        'Unable to deal with channel type %s!', type)
            end
            SetUIParam(mfilename,'gain',str2num(gain),'Enable','On')
        case 'Line'
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
    SetUIParam(mfilename,'units','String',' ','Enable','On')
    SetUIParam(mfilename,'gain','String',' ','Enable','On')
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
        used        = daq.Channel.HwChannel;
        if iscell(used)
            used        = [used{:}];
        end
        if ~isempty(used)
            channels    = setdiff(channels, used);
        end
    case 'digital io'
        channels    = daqhwinfo(daq, 'TotalLines');
        channels    = [0:channels-1];
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
SetUIParam(mfilename,'channel','String',cellstr(num2str(channels')));
        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateTelegraphs()
instrument  = GetUIParam(mfilename,'instrument_name');
telegraphs  = GetInstrumentTelegraphNames(instrument);
SetUIParam(mfilename,'telegraphs','String', telegraphs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = buttonHandler(obj, event)
tag = get(obj,'tag');
switch tag
    case 'digitizer'
        updateChannels
    case 'btn_cancel'
        DeleteModule(mfilename)
    otherwise
        warning('METAPHYS:tagCallbackUndefined',...
            'The GUI object with tag %s made an unsupported callback.',...
            tag)
end
