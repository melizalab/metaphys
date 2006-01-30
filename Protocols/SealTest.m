function [] = SealTest(action)
%
% SEALTEST A simple protocol used to test the resistance of an electrode.
%
% This is done by stepping the holding voltage between two different values
% and measuring the difference in current flow, or alternatively, by
% stepping the amount of current and measuring the change in the voltage.
% Thus, to support this protocol, an instrument must have at least one
% input and one output defined.
%
% The resistance is measured by sending a pulse through the amplifier's
% input and measuring the response from the output.  This pulse is sent
% repeatedly and plotted after each sweep.  If the instrument has
% telegraphs defined, these must be monitored so that the scaling is
% correct and the resistance measured correctly.  Measuring the resistance
% depends on the mode of the amplifier, so this must be determined from the
% telegraphs or the units of the channels.
%
% Unlike most protocols, SealTest runs in its own window and has its own
% start and stop buttons. Thus, the only action it has to support is
% 'init'.
%
% See also:  PROTOCOLTEMPLATE, SEALTEST_DEFAULT
%
% $Id: SealTest.m,v 1.11 2006/01/30 20:04:54 meliza Exp $


% Parse action
switch lower(action)
    case 'init'
        createFigure
        setupFigure
    case 'start'
        startProtocol
    case 'destroy'
        % no cleanup necessary
    otherwise
        error('METAPHYS:protocol:noSuchAction',...
            'No such action %s supported by protocol %s',...
            action, mfilename)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = startProtocol()
% Start the protocol running.

SetUIParam(me,'startbutton','String','Stop');
SetUIParam(me,'pulse_len','Enable','Off');
SetUIParam(me,'pulse_amp','Enable','Off');
SetUIParam(me,'pulse_base','Enable','Off');
SetUIParam(me,'command','Enable','Off');
StopDAQ
instrument  = GetUIParam(me,'instrument','selected');
AddSubscriber('sealtest', instrument, @plotData);
SetUIParam(me, 'axes', 'UserData',[]);  % used for the data cache
mystartSweep

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = mystartSweep(varargin)
% Starts the sweep (called by DataHandler and startProtocol)
%% Generate data pulse
instr                   = GetUIParam(me,'instrument','selected');
[pulse pulse_len]       = generatePulse(instr);
PutInputData(instr, pulse)
SetUIParam(me,'axes','XLim',[0 pulse_len]);
StartContinuous(pulse_len)
% StartSweep(pulse_len)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = stopProtocol()
% Stop the protocol from running.
DeleteSubscriber('sealtest')
StopDAQ
SetUIParam(me,'startbutton','String','Start');
SetUIParam(me,'pulse_len','Enable','On');
SetUIParam(me,'pulse_amp','Enable','On');
SetUIParam(me,'pulse_base','Enable','On');
SetUIParam(me,'command','Enable','On');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = plotData(packet)
% Called by DataHandler (or cachepacket)

output  = GetUIParam(me,'output','selected');
scaling = GetUIParam(me,'scaling','selected');
chan    = strmatch(output, packet.channels, 'exact');
if ~isempty(chan)
    ax  = GetUIHandle(me,'axes');
    switch scaling
        case 'auto'
            % matlab's auto feature is too tight, generally
            set(ax,'YLimMode','auto');
        case 'manual'
            set(ax,'YLimMode','manual');
        case '15'
            set(ax,'YLim',[-1 5]);
        case '11'
            set(ax,'YLim',[-1 1]);
    end
    time   = packet.time - packet.time(1);
    plot(time, packet.data(:,chan));
    ylabel(ax, sprintf('%s (%s)', packet.channels{chan}, packet.units{chan}))
    packet.data = packet.data(:,chan);
    packet.units= packet.units{chan};
    cacheData(packet)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = cacheData(packet)
% caches a fixed # of packets and then calls plotData
CACHE   = 10;
p   = GetUIParam(me, 'axes','UserData');
p   = cat(2,p,packet);
if size(p,2) < CACHE
    SetUIParam(me, 'axes', 'UserData', p);
else
    SetUIParam(me, 'axes', 'UserData', []);
    packet.data = mean([p.data],2);
    calculateResist(packet.time, packet.data, packet.units);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [pulse pulse_len] = generatePulse(instr)
% Generates the command pulse
len     = GetUIParam(me,'pulse_len','StringVal') / 1000;   % s
amp     = GetUIParam(me,'pulse_amp','StringVal');   % units
base    = GetUIParam(me,'pulse_base','StringVal');  % units
chans   = GetUIParam(me,'command');
chan    = GetUIParam(me,'command','Value');
Fs      = GetChannelSampleRate(instr, chans{chan});

% the actual data is twice as long as the pulse
len_s       = fix(len * Fs);
pulse_len_s = len_s * 2;
pulse_len   = len * 2;
% and the offset is 30%
off_s   = fix(pulse_len_s * 0.15);

pulse   = zeros(pulse_len_s, size(chans,1));
pulse(:,chan)   = base;
pulse(off_s:off_s+len_s,chan)  = base+amp;

% fix pulse length to ms
pulse_len   = pulse_len * 1000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = setupFigure()
% Populate the fields of the figure with the right options

%% instruments and related options
instruments = GetInstrumentNames;
SetUIParam(me, 'instrument', instruments);

%% populate with default values
defaults    = GetDefaults(me);  % this should NOT be empty

if isfield(defaults, 'pulse_amp')
    SetUIParam(me, 'pulse_amp', defaults.pulse_amp)
end
if isfield(defaults, 'pulse_len')
    SetUIParam(me, 'pulse_len', defaults.pulse_len)
end
%% instrument is the last one selected, otherwise defaults to currently
%% selected in metaphys
if isfield(defaults, 'instrument')
    instr   = defaults.instrument;
else
    instr   = '';
end
if isempty(strmatch(instr, instruments, 'exact'))
    instr   = GetUIParam('metaphys','instruments','selected');
end
SetUIParam(me, 'instrument', 'selected', instr)
pickInstrument

%% likewise with input and command; if no default use first channel (do
%% nothing)
if isfield(defaults, 'output')
    SetUIParam(me, 'output', 'selected', defaults.output);
end
if isfield(defaults, 'command')
    SetUIParam(me, 'command', 'selected', defaults.command);
end
pickCommand

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = pickInstrument(varargin)
% populates selection popups for output and command
instrument  = GetUIParam(me, 'instrument', 'selected');
if isempty(instrument)
    inputs  = {};
    outputs = {};
    btn_en  = 'Off';
else
    inputs  = GetInstrumentChannelNames(instrument, 'input');
    outputs = GetInstrumentChannelNames(instrument, 'output');
    btn_en  = 'On';
end
SetUIParam(me, 'output', outputs);
SetUIParam(me, 'command', inputs);
if isempty(outputs) || isempty(inputs)
    btn_en  = 'Off';
end
SetUIParam(me,'startbutton','Enable', btn_en);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = pickCommand(varargin)
% looks up the current units and holding value of the commandchannel
instrument  = GetUIParam(me, 'instrument', 'selected');
command     = GetUIParam(me, 'command', 'selected');
if ~isempty(instrument) && ~isempty(command)
    holding     = GetInstrumentChannelProps(instrument, command,...
        'DefaultChannelValue');
    units       = GetInstrumentChannelProps(instrument, command,...
        'Units');
    SetUIParam(me, 'pulse_base', num2str(holding))
    SetUIParam(me, 'pulse_base_units', units)
    SetUIParam(me, 'pulse_amp_units', units)
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function m = me()
% Returns the module name (lowercase of mfilename)
m   = lower(mfilename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = createFigure()
% Creates the SealTest figure. Note that we are using normalized units.

fig = FindFigure(me);
if ~isempty(fig)
    return
end

fig = OpenFigure(me,'CloseRequestFcn',@close_callback);
SetObjectDefaults(fig, 'figure')
ResizeFigure(fig,[560 420],'pixels')
bkgnd   = get(0,'defaultUicontrolBackgroundColor');

%% Axes
InitUIObject(me,'axes','axes','position',[0.09 0.25 0.5 0.7],...
    'Box','On','nextplot','replacechildren');
xlabel('Time (ms)')
%% Instrument selection panel
ph = uipanel('position',[0.62 0.68 0.35 0.3],...
    'title','Instrument');
[w h] = GetUIObjectSize(ph, 'pixels');
w   = w-20;
hw  = w/3;
h   = h-50;
InitUIControl(ph, me, 'instrument', 'style', 'popupmenu',...
    'position',[10 h w 20], 'String', ' ', 'Callback', @pickInstrument);

h   = h-30;
uicontrol(ph, 'style', 'text','String', 'Output:',...
    'position',[10 h hw 20],'HorizontalAlignment','left');
InitUIControl(ph, me, 'output', 'style', 'popupmenu',...
    'position', [10+hw h w-hw 20],'String', ' ');

h   = h-30;
uicontrol(ph, 'style', 'text', 'String', 'Command:',...
    'position', [10 h hw 20], 'HorizontalAlignment','left');
InitUIControl(ph, me, 'command', 'style', 'popupmenu',...
    'position', [10+hw h w-hw 20],'String',' ', 'Callback', @pickCommand);

%% Resistance display
ph  = uipanel('position',[0.62 0.42 0.35 0.25],...
    'title','Resistance');
% Input resistance
h(1) = uicontrol(ph,'style','text','String','Ri:',...
    'units','normalized','position',[0.1 0.5 0.1 0.4]);
h(2) = InitUIControl(ph, me, 'ri', 'style','text','String','0000',...
    'units','normalized','position',[0.3 0.5 0.4 0.4]);
h(3) = uicontrol(ph,'style','text','String','MOhm',...
    'units','normalized','position',[0.7 0.5 0.25 0.4]);
% Transient resistance
h(4) = uicontrol(ph,'style','text','String','Rt:',...
    'units','normalized','position',[0.1 0.1 0.1 0.4]);
h(5) = InitUIControl(ph, me, 'rt', 'style','text','String','0000',...
    'units','normalized','position',[0.3 0.1 0.4 0.4]);
h(6) = uicontrol(ph,'style','text','String','MOhm',...
    'units','normalized','position',[0.7 0.1 0.25 0.4]);
set(h,'FontSize',12)
set(h([2 5]),'ForegroundColor',[0 0 1],'BackgroundColor',...
    get(0,'defaultUicontrolBackgroundColor'));

%% Pulse Control
ph = uipanel('position',[0.62 0.20 0.35 0.22],'title','Pulse');
[w h] = GetUIObjectSize(ph, 'pixels');
w   = w-20;
labelw  = w/2;
boxw    = w/3;
unitw   = w/6;
% Pulse Size
h   = h-37;
uicontrol(ph, 'style', 'text','String', 'Amplitude:',...
    'position',[10 h-2 labelw 20],'HorizontalAlignment','left');
InitUIControl(ph, me, 'pulse_amp', 'style', 'edit',...
    'position', [10+labelw h boxw 20],'String', ' ',...
    'HorizontalAlignment','right');
InitUIControl(ph, me, 'pulse_amp_units', 'style', 'text',...
    'position',[10+labelw+boxw h-2 unitw 20],...
    'String','mV','HorizontalAlignment','right',...
    'BackgroundColor',bkgnd);    
% Pulse width
h   = h-22;
uicontrol(ph, 'style', 'text','String', 'Length:',...
    'position',[10 h-2 labelw 20],'HorizontalAlignment','left');
InitUIControl(ph, me, 'pulse_len', 'style', 'edit',...
    'position', [10+labelw h boxw 20],'String', ' ',...
    'HorizontalAlignment','right');
InitUIControl(ph, me, 'pulse_len_units', 'style', 'text',...
    'position',[10+labelw+boxw h-2 unitw 20],...
    'String','ms','HorizontalAlignment','right',...
    'BackgroundColor',bkgnd);
% Hold value
h   = h-22;
uicontrol(ph, 'style', 'text','String', 'Holding:',...
    'position',[10 h-2 labelw 20],'HorizontalAlignment','left');
InitUIControl(ph, me, 'pulse_base', 'style', 'edit',...
    'position', [10+labelw h boxw 20],'String', ' ',...
    'HorizontalAlignment','right');
InitUIControl(ph, me, 'pulse_base_units', 'style', 'text',...
    'position',[10+labelw+boxw h-2 unitw 20],...
    'String','mV','HorizontalAlignment','right',...
    'BackgroundColor',bkgnd);


%% Scaling
bgh = uibuttongroup('position',[.62 .02 0.35 0.17],...
    'Title','Scaling');
InitUIParam(me, 'scaling', bgh)
% four buttons: Auto, Manual, [-1 5] and [-1 1]
uicontrol(bgh,'style','radiobutton','String','Auto',...
    'tag','auto','position',[10 30 w/2 20])
uicontrol(bgh,'style','radiobutton','String','Manual',...
    'tag','manual','position',[10 10 w/2 20])
uicontrol(bgh,'style','radiobutton','String','[-1 5]',...
    'tag','15','position',[10+w/2 30 w/2-10 20])
uicontrol(bgh,'style','radiobutton','String','[-1 -1]',...
    'tag','11','position',[10+w/2 10 w/2-10 20])


%% Protocol control
h(1) = InitUIControl(me, 'startbutton', 'style', 'togglebutton',...
    'String', 'Start', 'units', 'normalized',...
    'position',[0.17 0.07 0.15 0.07],'Callback',{@run_callback});
h(2) = InitUIControl(me, 'closebutton', 'style', 'pushbutton',...
    'String', 'Close', 'units', 'normalized',...
    'position',[0.37 0.07 .15 0.07],'Callback',{@close_callback});
set(h,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = run_callback(obj, event)
% Handles the callback for the start/stop button
button_state    = GetUIParam(me, 'startbutton', 'Value');
if button_state==1
    startProtocol
else
    stopProtocol
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = close_callback(varargin)
% Handles the callback for the close actions
defaults    = struct('pulse_amp', GetUIParam(me, 'pulse_amp','stringval'),...
    'pulse_len', GetUIParam(me, 'pulse_len', 'stringval'),...
    'instrument', GetUIParam(me, 'instrument', 'selected'),...
    'output', GetUIParam(me, 'output', 'selected'),...
    'command', GetUIParam(me, 'command', 'selected'));
SetDefaults(me, 'control', defaults);
stopProtocol
DeleteModule(me)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
function [] = calculateResist(time, data, data_u)
% calculates the resistance of the electrode based on response to a voltage
% or current pulse.
pulse   = GetUIParam(me, 'pulse_amp', 'StringVal');
pulse_u = GetUIParam(me, 'pulse_amp_units', 'String');
% ax      = GetUIHandle(me, 'axes');
switch lower(pulse_u(end))
    case 'v'
        mode    = 'vpulse';
%         [Rt, Ri] = CalculateResistance(time, data, pulse, mode, ax);
    case 'a'
        mode    = 'ipulse';
%         [Rt, Ri] = CalculateResistance(time, data, pulse, mode, ax);
end
[Rt, Ri] = CalculateResistance(time, data, pulse, mode);
% figure out scaling; CalculateResistance works on SI units
scaling     = 1;
allunits    = {pulse_u data_u};
if any(strncmpi('mv', allunits,2))
    scaling = scaling / 1000;
end
if any(strncmpi('na', allunits,2))
    scaling = scaling * 1e9;
elseif any(strncmpi('pa', allunits,2))
    scaling = scaling * 1e12;
end

SetUIParam(me, 'ri', sprintf('%3.1f',Ri * scaling / 1e6));
SetUIParam(me, 'rt', sprintf('%3.1f',Rt * scaling / 1e6));
