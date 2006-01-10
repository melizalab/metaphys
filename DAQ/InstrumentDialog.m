function [] = InstrumentDialog(instrumentname)
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
% $Id: InstrumentDialog.m,v 1.1 2006/01/11 03:19:58 meliza Exp $

%% Open the figure
fig     = OpenGuideFigure(mfilename);

%% Populate the fields
% The instrument name is stored here for future access
SetUIParam(mfilename,'instrument_name',instrumentname);
updateInputs
updateOutputs
updateTelegraphs

%% Set callbacks
setCallbacks

set(fig,'WindowStyle','modal')
uiwait(fig)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = setCallbacks()
objects = {'input_add','input_edit','input_delete',...
    'output_add','output_edit','output_delete',...
    'telegraph_add','telegraph_edit','telegraph_delete',...
    'instrument_name','instrument_type','instrument_load',...
    'instrument_save'};
for i = 1:length(objects)
    SetUIParam(mfilename,objects{i},'Callback',@buttonHandler);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateInputs()
instrument  = GetUIParam(mfilename,'instrument_name');
inputs      = GetInstrumentChannelNames(instrument,'input');
SetUIParam(mfilename,'inputs','String', inputs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateOutputs()
instrument  = GetUIParam(mfilename,'instrument_name');
outputs     = GetInstrumentChannelNames(instrument,'output');
SetUIParam(mfilename,'outputs','String', outputs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateTelegraphs()
instrument  = GetUIParam(mfilename,'instrument_name');
telegraphs  = GetInstrumentTelegraphNames(instrument);
SetUIParam(mfilename,'telegraphs','String', telegraphs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = buttonHandler(obj, event)
tag = get(obj,'tag');
instrument  = GetUIParam(mfilename,'instrument_name');
switch tag
    case 'input_add'
        ChannelDialog(instrument,'input')
        updateInputs
    case 'input_edit'
        selected    = GetUIParam(mfilename,'inputs','Selected');
    otherwise
        warning('METAPHYS:tagCallbackUndefined',...
            'The GUI object with tag %s made an unsupported callback.',...
            tag)
end
