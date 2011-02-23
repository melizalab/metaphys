function varargout = DigitizerDialog(action)
%
% DIGITIZERDIALOG Dialogue box for setting up digitization hardware. 
%
% The user is given a list of available hardware, allowed to initialize the
% subsystems on any of the hardware, and set properties of the hardware.
%
% See also: INITDAQ, RESETDAQ, DELETEDAQ
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

switch lower(action)
    case 'init'
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
        varargout{1}    = fig;
    case 'destroy'
end

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
    SetUIParam(mfilename, 'triggertype', 'Callback', @updateTrigger);
    SetUIParam(mfilename, 'triggerdio', 'Callback', @updateTrigger);
    SetUIParam(mfilename, 'triggerline', 'Callback', @updateTrigger);
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
currentDAQs = GetUIParam(mfilename,'systems');
currentDAQ  = GetUIParam(mfilename,'systems','Selected');
if ~isempty(currentDAQ)
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

    % the trigger properties are synthetic so we have to do them by hand
    AI_TRIGGER_TYPES   = {'immediate','manual', 'linked', 'hardware'};
    AO_TRIGGER_TYPES   = {'immediate','manual', 'hardware'};
    DIGITAL_TYPE       = 'digital';

    % the daq type determines what options are available
    dtype   = GetDAQProperty(currentDAQ, 'Type');
    % we also have to check for digital daqs
    dtypes  = GetDAQProperty(currentDAQs, 'Type');
    dios    = strmatch('digital io', lower(dtypes));
    if ~isempty(dios)
        AI_TRIGGER_TYPES    = {AI_TRIGGER_TYPES{:} DIGITAL_TYPE};
        AO_TRIGGER_TYPES    = {AO_TRIGGER_TYPES{:} DIGITAL_TYPE};
        SetUIParam(mfilename,'triggerdio',currentDAQs{dios})
    else
        SetUIParam(mfilename,'triggerdio',{})
        ttype   = GetUIParam(mfilename,'triggertype','selected');
        % fix any triggers that don't work if the digital object is
        % gone
        if strcmpi(ttype,'digital')
            SetUIParam(mfilename,'triggertype','selected','hardware');
            updateTrigger
        end
    end

    switch lower(dtype)
        case 'analog input'
            SetUIParam(mfilename,'triggertype','String',AI_TRIGGER_TYPES,...
                'Enable','On')
        case 'analog output'
            SetUIParam(mfilename,'triggertype','String',AO_TRIGGER_TYPES,...
                'Enable','On')
        case 'digital io'
            SetUIParam(mfilename,'triggertype','Enable','Off')
    end
    % now try to figure out the trigger type
    [ttype dio dioline]   = GetDAQTrigger(currentDAQ);
    SetUIParam(mfilename,'triggertype','selected',ttype)
    if strcmpi(ttype,'digital')
        SetUIParam(mfilename,'triggerdio','enable','on')
        SetUIParam(mfilename,'triggerdio','selected',dio)
        SetUIParam(mfilename,'triggerline','String',num2str(dioline),...
            'Enable','On')
    else
        SetUIParam(mfilename,'triggerdio','Enable','Off')
        SetUIParam(mfilename,'triggerline',...
            'Enable','Off')
    end
else
    for i = 1:length(myproperties)
        SetUIParam(mfilename, lower(myproperties{i}),...
            'Enable','Off');
    end
    SetUIParam(mfilename,'triggertype','Enable','Off')
    SetUIParam(mfilename,'triggerdio','Enable','Off')
    SetUIParam(mfilename,'triggerline',...
        'Enable','Off')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateTrigger(obj, event)
daqn    = GetUIParam(mfilename,'systems','selected');
ttype   = GetUIParam(mfilename,'triggertype','selected');
tdio    = GetUIParam(mfilename,'triggerdio','selected');
tline   = GetUIParam(mfilename,'triggerline','stringval');
switch ttype
    case {'immediate','manual','linked','hardware'}
        SetDAQTrigger(ttype, daqn)
    case 'digital'
        SetDAQTrigger('digital',daqn,[],tdio,tline)
end
updateProperties(obj, event)

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
    samplerate  = GetUIParam(mfilename,'samplerate','stringval');
    inputtype   = GetUIParam(mfilename,'inputtype','selected');
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
    if strcmpi(GetUIParam(mfilename,'inputtype','Enable'),'On')
        SetDAQProperty(daqname,'InputType',inputtype)
    end
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
                                           j,...
                                           1);
            count = count+1;
        end
        if ~isempty(hwinfo.ObjectConstructorName{j, 2})
            hwstruct(count) = makeHwStruct(hwinfo.AdaptorName,...
                                           'ao',...
                                           hwinfo.InstalledBoardIds{j},...
                                           j,...
                                           2);
            count = count+1;
        end
        if ~isempty(hwinfo.ObjectConstructorName{j, 3})
            hwstruct(count) = makeHwStruct(hwinfo.AdaptorName,...
                                           'dio',...
                                           hwinfo.InstalledBoardIds{j},...
                                           j,...
                                           3);
            count = count+1;
        end        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hwstruct = makeHwStruct(adaptorName, type, adaptorid, adaptornum, constructorid)
name  = sprintf('%s_%s_%s',...
                adaptorName,...
                adaptorid,...
                type);
hwstruct = struct('name', name,...
                  'hwname',adaptorName,...
                  'hwnum', adaptornum,...
                   'constructor', constructorid);
