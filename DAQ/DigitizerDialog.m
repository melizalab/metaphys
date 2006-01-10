function [] = DigitizerDialog()
%
% DIGITIZERDIALOG Dialogue box for setting up digitization hardware. 
%
% The user is given a list of available hardware, allowed to initialize the
% subsystems on any of the hardware, and set properties of the hardware.
%
% See Also: INITDAQ, RESETDAQ, DELETEDAQ
%
% $Id: DigitizerDialog.m,v 1.1 2006/01/10 20:59:50 meliza Exp $

%% Open the figure
fig     = OpenGuideFigure(mfilename);

%% Hardware context menu
m   = uicontextmenu;
uimenu(m, 'label', 'Activate', 'tag', 'm_daq_activate', 'callback', @menu)
uimenu(m, 'label', 'Properties...', 'tag', 'm_daq_props', 'callback', @menu)

%% Populate the hardware field
hwstruct    = getHWStruct;
if ~isempty(hwstruct)
    SetUIParam(mfilename, 'hardware', 'String', {hwstruct.name},...
               'UserData', hwstruct, 'Enable', 'On',...
               'UIContextMenu', m, 'Callback', @hardware_click)
else
    SetUIParam(mfilename, 'hardware', 'String', 'No valid hardware!',...
        'Enable', 'Inactive', 'UIContextMenu', [],...
        'Callback', [])
end

%% Populate the systems field
updateSystems
SetUIParam(mfilename,'btn_close','Callback','closereq')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateSystems()
% Sets up systems panel

%% Context menu
m   = uicontextmenu;
uimenu(m, 'label', 'Deactivate', 'tag', 'm_daq_deactivate', 'callback',...
    @menu)
uimenu(m, 'label', 'Reset', 'tag', 'm_daq_reset', 'callback', @menu)
uimenu(m, 'label', 'Properties...', 'tag', 'm_daq_inspect',...
    'callback', @menu)

%% Populate systems field
daqnames    = GetDAQNames;
if ~isempty(daqnames)
    SetUIParam(mfilename, 'systems', 'String', daqnames,...
        'Value',1,...
        'Enable', 'On', 'UIContextMenu', m, 'Callback', @updateProperties)
else
    SetUIParam(mfilename, 'systems', 'String', ' ', 'Enable', 'Inactive',...
        'Value',1,...
        'UIContextMenu', [], 'Callback', [])
end
updateProperties

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateProperties(obj, event)
% Retrieves properties from the current object and displays them
myproperties    = {'Type','SampleRate', 'InputType'};
currentDAQ  = GetUIParam(mfilename,'systems','Selected');
if ~strcmpi(currentDAQ, ' ')
    for i = 1:length(myproperties)
        if IsDAQProperty(currentDAQ, myproperties{i})
            info    = GetDAQPropInfo(currentDAQ, myproperties{i});
            value   = GetDAQProperty(currentDAQ, myproperties{i});
            switch info.Constraint
                case 'enum'
                    SetUIParam(mfilename, lower(myproperties{i}),...
                        'String', info.ConstraintValue,...
                        'Value', strmatch(value, info.ConstraintValue),...
                        'Enable','On',...
                        'Callback',@setProperties)
                otherwise
                    if strcmpi(info.Type, 'double')
                            value   = num2str(value);
                    end
                    SetUIParam(mfilename, lower(myproperties{i}),...
                        'String', value,...
                        'Enable','On',...
                        'Callback',@setProperties)
            end
        else
            SetUIParam(mfilename, lower(myproperties{i}),...
                'Enable','Off');
        end
    end
else
    for i = 1:length(myproperties)
        SetUIParam(mfilename, lower(myproperties{i}),...
            'Enable','Off');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = menu(obj, event)
% Handles menu events
tag = get(obj,'tag');
switch tag
    case 'm_daq_activate'
        activateSelectedHardware;
    case 'm_daq_props'
        hwselected  = GetUIParam(mfilename,'hardware','Value');
        hwinfo      = GetUIParam(mfilename,'hardware','UserData');
        z           = daqhwinfo(hwinfo(hwselected).hwname);
        openvar('z')
    case 'm_daq_deactivate'
        hwselected  = GetUIParam(mfilename,'systems','Selected');
        DeleteDAQ(hwselected)
        updateSystems
    case 'm_daq_reset'
        hwselected  = GetUIParam(mfilename,'systems','Selected');
        ResetDAQ(hwselected)
        updateSystems
    case 'm_daq_inspect'
        hwselected  = GetUIParam(mfilename,'systems','Selected');
        daq         = GetDAQ(hwselected);
        % Unfornately there is no way to make this dialog modal, which can
        % result in desynchronization with the properties we display.
        inspect(daq)
    otherwise
        DebugPrint('No action has been defined for object with tag %s.',...
            tag);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = activateSelectedHardware()
% Activates the selected item in the hardware list
hwselected  = GetUIParam(mfilename,'hardware','Value');
hwdata      = GetUIParam(mfilename,'hardware','UserData');
% There shouldn't be a problem with re-activating a device
InitDAQ(hwdata(hwselected).hwname,...
    hwdata(hwselected).hwnum,...
    hwdata(hwselected).constructor);
updateSystems

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = setProperties(obj, event)
% Handles changes to properties
daqname     = GetUIParam(mfilename,'systems','selected');
if ~strcmpi(daqname, ' ')
    samplerate  = GetUIParam(mfilename,'sample_rate','stringval');
    inputtype   = GetUIParam(mfilename,'input_type','selected');
    % Check the values of the properties
    srinfo  = GetDAQPropInfo(daqname,'SampleRate');
    if samplerate < srinfo.ConstraintValue(1) 
        errordlg(sprintf('Values must be between %3.3f and %3.0f',...
            srinfo.ConstraintValue),'Value out of range error')
        samplerate  = srinfo.ConstraintValue(1);
    elseif samplerate > srinfo.ConstraintValue(2)
        errordlg(sprintf('Values must be between %3.3f and %3.0f',...
            srinfo.ConstraintValue),'Value out of range error')
        samplerate  = srinfo.ConstraintValue(2);
    end
    % set the properties
    SetDAQProperty(daqname,'SampleRate',samplerate)
    SetDAQProperty(daqname,'InputType',inputtype)
    % update the display
    updateProperties
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = hardware_click(obj, event)
% Handles clicks on the hardware list. Double clicks result in activation
% of the selected hardware.
if strcmpi(get(gcf,'SelectionType'),'open')
    activateSelectedHardware
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hwstruct   = getHWStruct()
count       = 1;
daqhw       = daqhwinfo;
adaptors    = daqhw.InstalledAdaptors;
for i = 1:length(adaptors)
    hwinfo  = daqhwinfo(adaptors{i});
    for j = 1:length(hwinfo.InstalledBoardIds)
        if ~isempty(hwinfo.ObjectConstructorName{j, 1})
            hwstruct(count) = makeHwStruct(hwinfo.AdaptorName,...
                                           'ai',...
                                           hwinfo.InstalledBoardIds{j},...
                                           1);
            count = count+1;
        end
        if ~isempty(hwinfo.ObjectConstructorName{j, 2})
            hwstruct(count) = makeHwStruct(hwinfo.AdaptorName,...
                                           'ao',...
                                           hwinfo.InstalledBoardIds{j},...
                                           2);
            count = count+1;
        end
        if ~isempty(hwinfo.ObjectConstructorName{j, 3})
            hwstruct(count) = makeHwStruct(hwinfo.AdaptorName,...
                                           'dio',...
                                           hwinfo.InstalledBoardIds{j},...
                                           3);
            count = count+1;
        end        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hwstruct = makeHwStruct(adaptorName, type, adaptorid, constructorid)
name  = sprintf('%s_%s_%s',...
                adaptorName,...
                adaptorid,...
                type);
hwstruct = struct('name', name,...
                  'hwname',adaptorName,...
                  'hwnum', str2num(adaptorid),...
                   'constructor', constructorid);
