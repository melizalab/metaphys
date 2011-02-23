function varargout = TelegraphDialog(action, instrumentname, telegraph)
%
% TELEGRAPHDIALOG Dialogue box for configuring instrument telegraphs.
%
% The telegraphs referred to here are virtual devices that refer to real
% channels on real DAQ hardware, but are associated with a particular
% instrument. Depending on the instrument, the number and type of inputs
% and outputs will vary.
%
% TELEGRAPHDIALOG(instrumentname) creates a new telegraph
%
% TELEGRAPHDIALOG(instrumentname, telegraphname) edits an existing telegraph
%
%
% See also: ADDINSTRUMENTTELEGRAPH
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

switch action
    case {'init', 'modal'}
        %% Open the figure
        fig     = OpenGuideFigure(mfilename);

        %% Populate the fields
        TELEGRAPH_TYPES = {'','Axon 200x','Axon 1x','Axon 700x'};
        SetUIParam(mfilename,'instrument_name',instrumentname);
        SetUIParam(mfilename,'type','String',TELEGRAPH_TYPES,'Value',1);

        if nargin > 2
            tele  = GetTelegraph(instrumentname, telegraph);
        else
            tele  = telegraph_struct;
        end
        SetUIParam(mfilename,'name',tele.name)
        SetUIParam(mfilename,mfilename,'UserData',tele)

        makePanel
        % set the channel options
        pickAI
        % update the values
        updateFigure(tele)
        % make the right stuff visible
        updatePanel

        
        %% Set callbacks
        setCallbacks
        if strcmpi(action,'modal')
            set(fig,'WindowStyle','modal')
            uiwait(fig)
        end
        varargout{1}    = fig;
    case 'destroy'
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = setCallbacks()
objects = {'type','btn_ok','btn_cancel'};
for i = 1:length(objects)
    SetUIParam(mfilename,objects{i},'Callback',@buttonHandler);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updatePanel()
% Makes sure the right panel options are visible
CONTROLS_200X = {'txt_daq','tele_daq','txt_mode','tele_mode','txt_gain',...
    'tele_gain','txt_out','tele_out'};
CONTROLS_1X = {'txt_daq','tele_daq','txt_gain',...
    'tele_gain','txt_out','tele_out'};

type    = GetUIParam(mfilename,'type','selected');

%% Make all children of panel invisible
pnlh        = GetUIHandle(mfilename,'pnl_settings');
kids        = get(pnlh,'Children');
set(kids,'Visible','Off','Enable','Off');

h   = [];
%% Switch on the objects we need
switch type
    case 'Axon 200x'
        % mode and gain telegraphs, both on the same daq
        h   = GetUIHandle(mfilename, CONTROLS_200X);
    case 'Axon 1x'
        h   = GetUIHandle(mfilename, CONTROLS_1X);
    case 'Axon 700x'
        warning('METAPHYS:unsupportedOption',...
            'Axon 700x telegraphs not supported yet.')
end

set(h,'Visible','On','Enable','On')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = updateFigure(tele)
% Updates values in the figure

if isempty(tele)
    return
end
switch lower(tele.type)
    case '200x'
        SetUIParam(mfilename, 'type', 'selected', 'Axon 200x')
    case '1x'
        SetUIParam(mfilename, 'type', 'selected', 'Axon 1x')
    case '700x'
        SetUIParam(mfilename, 'type', 'selected', 'Axon 700x')
    otherwise
        SetUIParam(mfilename, 'type', 'Value', 1)
end
if ~isempty(tele.obj)
    if isvalid(tele.obj(1))
        daqn    = get(tele.obj(1).Parent,'Name');
        SetUIParam(mfilename,'tele_daq','selected',daqn)
        pickAI
        gainc   = tele.obj(1).HwChannel;
        SetUIParam(mfilename,'tele_gain','selected',num2str(gainc))
    else
        warning('METAPHYS:telegraphdialog:invalidChannel',...
            'The first channel object in the telegraph was invalid.')
    end
    if length(tele.obj) > 1
        if isvalid(tele.obj(2))
            modec   = tele.obj(2).HwChannel;
            SetUIParam(mfilename,'tele_mode','selected',num2str(modec));
        else
            warning('METAPHYS:telegraphdialog:invalidChannel',...
                'The second channel object in the telegraph was invalid.')
        end
    end
end
if ~isempty(tele.output)
    % this is a named channel on the current instrument
    SetUIParam(mfilename,'tele_out','Selected',tele.output);
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = makePanel
% populates the panel with uicontrols
h           = GetUIHandle(mfilename,'pnl_settings');
% get some data we might need
instr       = GetUIParam(mfilename,'instrument_name');
daqs        = GetDAQNames('analoginput');
[out]       = GetInstrumentChannelNames(instr);
c           = get(0,'defaultUicontrolBackgroundColor');
% this should NOT happen but bad things happen if we don't check
if isempty(out)
    warning('METAPHYS:telegraphdialog:noOutputs',...
        'At least one output must be defined to add a telegraph.')
    out = ' ';
end

InitUIControl(h,mfilename,'txt_daq','style','text',...
    'String','Digitizer:','units','normalized',...
    'BackgroundColor',c,...
    'position',[0.05 0.8 0.4 0.12]);
InitUIControl(h,mfilename,'tele_daq','style','popupmenu',...
    'String',daqs,'units','normalized',...
    'position',[0.55 0.8 0.4 0.12],...
    'Value',1,...
    'callback',@pickAI);

InitUIControl(h,mfilename,'txt_mode','style','text',...
    'String','Mode Channel:','units','normalized',...
    'BackgroundColor',c,...
    'position',[0.05 0.67 0.4 0.12]);
InitUIControl(h,mfilename,'tele_mode','style','popupmenu',...
    'String',' ','units','normalized',...
    'Value',1,...
    'position',[0.55 0.67 0.4 0.12]);

InitUIControl(h,mfilename,'txt_gain','style','text',...
    'String','Gain Channel:','units','normalized',...
    'BackgroundColor',c,...
    'position',[0.05 0.54 0.4 0.12]);
InitUIControl(h,mfilename,'tele_gain','style','popupmenu',...
    'String',' ','units','normalized',...
    'Value',1,...
    'position',[0.55 0.54 0.4 0.12]);

InitUIControl(h,mfilename,'txt_out','style','text',...
    'String','Scaled Channels:','units','normalized',...
    'BackgroundColor',c,...
    'position',[0.05 0.41 0.4 0.12]);
InitUIControl(h,mfilename,'tele_out','style','listbox',...
    'String',out,'units','normalized',...
    'Max',2,'Value',1,...
    'position',[0.1 0.04 0.8 0.36]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = pickAI(varargin)
daqname = GetUIParam(mfilename,'tele_daq','selected');
hwchan  = GetDAQHwChannels(daqname);
SetUIParam(mfilename,'tele_mode','String',...
    cellstr(strjust(num2str(hwchan'),'left')));
SetUIParam(mfilename,'tele_gain','String',...
    cellstr(strjust(num2str(hwchan'),'left')));
        
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s  = getData()
% Returns a structure with all the data in the figure
s   = struct('instrument',GetUIParam(mfilename,'instrument_name'),...
    'name',GetUIParam(mfilename,'name'),...
    'type',GetUIParam(mfilename,'type','Selected'),...
    'daq',GetUIParam(mfilename,'tele_daq','Selected'),...
    'mode',str2double(GetUIParam(mfilename,'tele_mode','Selected')),...
    'gain',str2double(GetUIParam(mfilename,'tele_gain','Selected')),...
    'out',{cellstr(GetUIParam(mfilename,'tele_out','Selected'))});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = buttonHandler(obj, event)
tag = get(obj,'tag');
switch tag
    case 'type'
        updatePanel
    case 'btn_cancel'
        DeleteModule(mfilename)
    case 'btn_ok'
        tele    = getData;
        if isempty(tele.name) || isempty(tele.type)
            errordlg('The telegraph must have a name and type.')
        elseif ~isnan(str2double(tele.name(1)))
            errordlg('Telegraph names must begin with a letter.')
        else
            oldtele = GetUIParam(mfilename,mfilename,'UserData');
            if ~isempty(oldtele.name)
                DeleteInstrumentTelegraph(tele.instrument,...
                    oldtele.name)
            end
            switch tele.type
                case 'Axon 200x'
                    AddInstrumentTelegraph(tele.instrument,...
                        tele.name,...
                        '200x',...
                        tele.daq,...
                        tele.mode,...
                        tele.gain,...
                        tele.out);
                    DeleteModule(mfilename)
                case 'Axon 1x'
                    AddInstrumentTelegraph(tele.instrument,...
                        tele.name,...
                        '1x',...
                        tele.daq,...
                        tele.gain,...
                        tele.out);
                    DeleteModule(mfilename)
                otherwise
                    error('METAPHYS:telegraphDialog',...
                        'Unsupported Telegraph type %s.', tele.type)
            end
        end

end

