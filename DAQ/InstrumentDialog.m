function [] = InstrumentDialog(action, instrumentname)
%
% INSTRUMENTDIALOG Dialogue box for configuring instruments.
%
% Instruments are virtual devices that contain input, output, and telegraph
% channels. Telegraph channels are virtual channels that refer to existing
% input and output channels. The user can define a set of instruments for
% an experiment, and save them individually.
%
% See Also: INITINSTRUMENT, ADDINSTRUMENTTELEGRPAH, ADDINSTRUMENTINPUT
%
% $Id: InstrumentDialog.m,v 1.8 2006/01/28 01:12:07 meliza Exp $

switch lower(action)
    case {'init', 'modal'}
    %% Open the figure
    fig     = OpenGuideFigure(mfilename);

    %% Populate the fields
    % The instrument name is stored here for future access
    SetUIParam(mfilename,'instrument_name','String',instrumentname,...
        'UserData',instrumentname);
    updateFigure

    %% Set callbacks
    setCallbacks

    if strcmpi(action,'modal')
        set(fig,'WindowStyle','modal')
        uiwait(fig)
    end
    case 'destroy'
    % do nothing
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateFigure()
updateInputs
updateOutputs
updateTelegraphs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = setCallbacks()
objects = {'input_add','input_edit','input_delete',...
    'output_add','output_edit','output_delete',...
    'telegraph_add','telegraph_edit','telegraph_delete',...
    'instrument_name','instrument_type'};
for i = 1:length(objects)
    SetUIParam(mfilename,objects{i},'Callback',@buttonHandler);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateInputs()
instrument  = GetUIParam(mfilename,'instrument_name');
[inputs, pretty]  = GetInstrumentChannelNames(instrument,'input');
SetUIParam(mfilename,'inputs','String', pretty, 'UserData', inputs,...
    'Enable','On')
if isempty(inputs)
    SetUIParam(mfilename,'inputs','Enable','Off')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateOutputs()
instrument  = GetUIParam(mfilename,'instrument_name');
[outputs, pretty]     = GetInstrumentChannelNames(instrument,'output');
SetUIParam(mfilename,'outputs','String', pretty, 'UserData', outputs,...
    'Enable','On')
if isempty(outputs)
    SetUIParam(mfilename,'outputs','Enable','Off')
    SetUIParam(mfilename,'telegraph_add','Enable','Off')
    SetUIParam(mfilename,'telegraph_edit','Enable','Off')
else
    SetUIParam(mfilename,'telegraph_add','Enable','On')
    SetUIParam(mfilename,'telegraph_edit','Enable','On')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateTelegraphs()
instrument  = GetUIParam(mfilename,'instrument_name');
telegraphs  = GetInstrumentTelegraphNames(instrument);
SetUIParam(mfilename,'telegraphs','String', telegraphs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = buttonHandler(obj, event)
tag = get(obj,'tag');
inputdaq    = GetDAQNames('analogoutput');
outputdaq   = GetDAQNames('analoginput');
instrument  = GetUIParam(mfilename,'instrument_name');
switch tag
    case 'input_add'
        if isempty(inputdaq)
            warndlg({'No digitizer devices for this type have been activated.',...
                'Set up digitizer properties before creating channels.'})
        else
            ChannelDialog('modal',instrument,'input');
            updateInputs
        end
    case 'input_edit'
        if isempty(inputdaq)
            warndlg({'No digitizer devices for this type have been activated.',...
                'Set up digitizer properties before creating channels.'})
        else
            channels    = GetUIParam(mfilename,'inputs','UserData');
            selected    = GetUIParam(mfilename,'inputs','Value');
            if ~isempty(channels)
                ChannelDialog('modal',instrument,channels{selected});
                updateInputs
            end
        end
    case 'input_delete'
        channels    = GetUIParam(mfilename,'inputs','UserData');
        selected    = GetUIParam(mfilename,'inputs','Value');
        if ~isempty(channels)
            DeleteInstrumentChannel(instrument, channels{selected})
            updateInputs
        end
    case 'output_add'
        if isempty(outputdaq)
            warndlg({'No digitizer devices for this type have been activated.',...
                'Set up digitizer properties before creating channels.'})
        else
            ChannelDialog('modal',instrument,'output');
            updateOutputs
        end
    case 'output_edit'
        if isempty(outputdaq)
            warndlg({'No digitizer devices for this type have been activated.',...
                'Set up digitizer properties before creating channels.'})
        else
            channels    = GetUIParam(mfilename,'outputs','UserData');
            selected    = GetUIParam(mfilename,'outputs','Value');
            if ~isempty(channels)
                ChannelDialog('modal',instrument,channels{selected});
                updateOutputs
            end
        end
    case 'output_delete'
        channels    = GetUIParam(mfilename,'outputs','UserData');
        selected    = GetUIParam(mfilename,'outputs','Value');
        if ~isempty(channels)
            DeleteInstrumentChannel(instrument, channels{selected})
            updateOutputs
        end
    case 'instrument_name'
        newname     = GetUIParam(mfilename,'instrument_name');
        oldname     = GetUIParam(mfilename,'instrument_name','UserData');
        if ~isnan(str2double(newname(1)))
            errordlg('Instrument names must begin with a letter.')
        else
            RenameInstrument(oldname, newname);
            SetUIParam(mfilename,'instrument_name','UserData',newname);
        end
        updateFigure
    case 'telegraph_add'
        TelegraphDialog('modal',instrument);
        updateTelegraphs
    case 'telegraph_edit'
        selected    = GetUIParam(mfilename,'telegraphs','Selected');
        if ~isempty(selected)
            TelegraphDialog('modal',instrument, selected);
        end
    case 'telegraph_delete'
        selected    = GetUIParam(mfilename,'telegraphs','Selected');
        if ~isempty(selected)
            DeleteInstrumentTelegraph(instrument, selected);
            updateTelegraphs
        end
        
    otherwise
        warning('METAPHYS:tagCallbackUndefined',...
            'The GUI object with tag %s made an unsupported callback.',...
            tag)
end
