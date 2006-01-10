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
% See Also:  PROTOCOLTEMPLATE
%
% $Id: SealTest.m,v 1.1 2006/01/10 20:59:52 meliza Exp $


% Parse action
switch lower(action)
    case 'init'
        createFigure
        setupFigure
    case 'start'
        startProtocol
    case 'stop'
        stopProtocol
    otherwise
        error('METAPHYS:protocol:noSuchAction',...
            'No such action %s supported by protocol %s',...
            action, mfilename)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = startProtocol()
% Start the protocol running.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = stopProtocol()
% Stop the protocol from running.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = setupFigure()
% Populate the fields of the figure with the right options

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function m = me()
% Returns the module name (lowercase of mfilename)
m   = lower(mfilename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = createFigure()
% Creates the SealTest figure. Note that we are using normalized units.

fig = OpenFigure(me,'CloseRequestFcn',@close_callback);
SetObjectDefaults(fig, 'figure')
ResizeFigure(fig,[560 420],'pixels')

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
    'position',[10 h w 20], 'String', ' ', 'HorizontalAlignment','right');

h   = h-30;
uicontrol(ph, 'style', 'text','String', 'Output:',...
    'position',[10 h hw 20],'HorizontalAlignment','left');
InitUIControl(ph, me, 'output', 'style', 'popupmenu',...
    'position', [10+hw h w-hw 20],'String', ' ', 'HorizontalAlignment','right');

h   = h-30;
uicontrol(ph, 'style', 'text', 'String', 'Command:',...
    'position', [10 h hw 20], 'HorizontalAlignment','left');
InitUIControl(ph, me, 'command', 'style', 'popupmenu',...
    'position', [10+hw h w-hw 20],'String',' ', 'HorizontalAlignment','right');

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
ph = uipanel('position',[0.62 0.22 0.35 0.2],'title','Pulse');
[w h] = GetUIObjectSize(ph, 'pixels');
w   = w-20;
labelw  = w/2;
boxw    = w/3;
unitw   = w/6;
% Pulse Size
h   = h-40;
uicontrol(ph, 'style', 'text','String', 'Amplitude:',...
    'position',[10 h-2 labelw 20],'HorizontalAlignment','left');
InitUIControl(ph, me, 'pulse_amp', 'style', 'edit',...
    'position', [10+labelw h boxw 20],'String', ' ',...
    'HorizontalAlignment','right');
InitUIControl(ph, me, 'pulse_units', 'style', 'text',...
    'position',[10+labelw+boxw h-2 unitw 20],...
    'String','mV','HorizontalAlignment','right',...
    'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));    
% Pulse width
h   = h-30;
uicontrol(ph, 'style', 'text','String', 'Length:',...
    'position',[10 h-2 labelw 20],'HorizontalAlignment','left');
InitUIControl(ph, me, 'pulse_len', 'style', 'edit',...
    'position', [10+labelw h boxw 20],'String', ' ',...
    'HorizontalAlignment','right');
uicontrol(ph, 'style', 'text',...
    'position',[10+labelw+boxw h-2 unitw 20],...
    'String','ms','HorizontalAlignment','right');

%% Scaling
%h   = h-20;
% uicontrol(ph, 'style', 'text','String', 'Scaling:',...
%     'position',[10 h-2 labelw 20],'HorizontalAlignment','left');
bgh = uibuttongroup('position',[.62 .05 0.35 0.17],...
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
function [] = run_callback(handle)
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
DeleteModule(me)

% InitUIControl(ph, me, 'pulse_len', 'style', 'edit',...
%     'position', [10+labelw h boxw 20],'String', ' ',...
%     'HorizontalAlignment','right');
% uicontrol(ph, 'style', 'text',...
%     'position',[10+labelw+boxw h-2 unitw 20],...
%     'String','ms','HorizontalAlignment','right'); 

% 
% error(nargchk(1,Inf,nargin));
% if isobject(varargin{1})
%     feval(varargin{3},varargin{1:2});
%     return;
% end
% action = lower(varargin{1});
% switch lower(action)
%     
% case 'standalone'
% 
%     initializeHardware(me);
%     SealTest('init');
%     
% case 'init'
%     OpenGuideFigure(me);
% 
%     wc.sealtest.pulse         = 5;
%     wc.sealtest.pulse_length  = 0.04;
%     wc.sealtest.n_sweeps      = 3;
%     wc.sealtest.scaling       = [1 0 0 0];  % the default is auto
% 
%     SetUIParam(me,'axes','NextPlot','ReplaceChildren');
%     lbl = get(wc.sealtest.handles.axes,'XLabel');
%     set(lbl,'String','Time (ms)');
%     lbl = get(wc.sealtest.handles.axes,'YLabel');
%     set(lbl,'String',['Current (' get(wc.ai.Channel(1),'Units') ')']);
%     
%     SetUIParam(me,'pulse','String',num2str(wc.sealtest.pulse))
%     SetUIParam(me,'commandUnits','String',get(wc.ao.Channel(1),'Units'));
%     SetUIParam(me,'sweeps','String',num2str(wc.sealtest.n_sweeps));
%     SetUIParam(me,'pulseLengthUnits','String','ms');
%     SetUIParam(me,'pulse_length','String',num2str(1000 .* wc.sealtest.pulse_length));
%     SetUIParam(me,'scaling_0','Value',1);
%     
% % these callbacks are associated with buttons in the GUI.  See SealTest.fig to change
% case 'sweeps_callback'
%     try
%         n_sweeps = str2num(get(wc.sealtest.handles.sweeps,'String'));
%         wc.sealtest.n_sweeps = n_sweeps;
%     catch
%         SetUIParam(me,'sweeps','String',num2str(wc.sealtest.n_sweeps));
%     end
%     
% case 'pulse_length_callback'
%     try
%         pulse_length = str2num(GetUIParam(me, 'pulse_length','String'));
%         wc.sealtest.pulse_length = pulse_length / 1000;
%     catch
%         SetUIParam(me,'pulse_length','String',num2str(wc.sealtest.pulse_length));
%     end
%     run(me,'reset');
%         
% case 'pulse_callback'
%     try
%         pulse = str2num(GetUIParam(me,'pulse','String'));
%         wc.sealtest.pusle =  pulse;
%     catch
%         SetUIParam(me, 'pulse','String',num2str(wc.sealtest.pulse));
%     end
%     run(me,'reset');
%     
% case 'scaling_callback'
%     setScaling(me);
%     
% case 'close_callback'
%     ClearAI(wc.ai);
%     ClearAO(wc.ao);
%     DeleteFigure(me);
%     
% case 'run_callback'
%     run(me,'switch');
%     
% otherwise
%     disp([action ' is not supported yet.']);
%     
% end
% 
% % local functions
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% 
% function out = me()
% out = mfilename;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% function run(fcn,action)
% global wc
%     state = GetUIParam(me,'runbutton','Value');
%     if (state > 0)
%         SetUIParam(me,'runbutton','String','Running');
%         setupSweep(me);
%         wc.sealtest.resist = [];
%         StartAcquisition(me,[wc.ai wc.ao]);
%     else
%         SetUIParam(me,'runbutton','String','Stopped');
%         stop([wc.ai wc.ao]);
%     end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% function setScaling(fcn)
% global wc
% % there has GOT to be a better way to handle this
% h        = wc.sealtest.handles;
% buttons  = [h.scaling_0 h.scaling_1 h.scaling_2 h.scaling_3];
% v        = get(buttons,'Value');
% values   = [v{1} v{2} v{3} v{4}];
% switched = values - wc.sealtest.scaling;
% set(buttons(find(switched > 0)),'Value',1);
% set(buttons(find(switched < 1)),'Value',0);
% v        = get(buttons,'Value');
% wc.sealtest.scaling = [v{1} v{2} v{3} v{4}];
% switch num2str(find(wc.sealtest.scaling))
%     case '1'
%         SetUIParam(me,'axes',{'YLimMode'},{'auto'});
%     case '2'
%         SetUIParam(me,'axes','YLim',[-5 5]);
%     case '3'
%         SetUIParam(me,'axes','YLim',[-1 5]);
%     case '4'
%         SetUIParam(me,'axes','YLim',[-1 1]);
%     otherwise
%         SetUIParam(me,'axes',{'YLimMode','XLimMode'},{'manual','manual'});
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% function initializeHardware(fcn)
% % This function initializes the WC structure and the DAQ when the
% % module is called in standalone mode.
% global wc
% 
% InitWC;
% InitDAQ(5000);
% 
% wc.control.amplifier      = CreateChannel(wc.ai, 0, {'ChannelName','Units'}, {'Im','nA'});
% wc.control.telegraph.gain = 2;
% CreateChannel(wc.ai, wc.control.telegraph.gain);
% wc.control.command        = CreateChannel(wc.ao, 0,...
%     {'ChannelName','Units','UnitsRange'},{'Vcommand', 'mV', [-200 200]}); % 20 mV/V
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function setupSweep(fcn)
% % each sweep is twice as long as the pulse.  we have to convert between
% % samples and time rather too often.
% global wc
% acq     = @analyze;
% [start, finish, sweeplen]        = pulseTimes;
% numouts          = length(wc.ao.Channel);
% wc.control.pulse = zeros(sweeplen,numouts);
% wc.control.pulse(start:finish,1) = wc.sealtest.pulse;  % here we assume the first channel is the command
% set(wc.ai,'SamplesPerTrigger',inf);
% set(wc.ai,'SamplesAcquiredAction',{me, acq})
% set(wc.ai,'SamplesAcquiredActionCount',length(wc.control.pulse));
% sr               = get(wc.ai,'SampleRate');
% set(wc.ao,'SampleRate',sr);
% set(wc.ai,'UserData',length(wc.control.pulse));
% set([wc.ai wc.ao],'StopAction','daqaction')
% set([wc.ai wc.ao],'TriggerType','Manual')
% set(wc.ai,'ManualTriggerHwOn','Trigger')
% putdata(wc.ao, wc.control.pulse);
% set(wc.ao,'RepeatOutput',inf);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [start, finish, total] = pulseTimes;
% global wc
% len     = fix(wc.sealtest.pulse_length .* wc.control.SampleRate);
% total   = 2 .* len;
% start   = fix(.5 .* len);
% finish  = start + len;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [] = analyze(obj, event)
% % This function gets called as a result of the SamplesAcquiredAction.  It
% % retrieves the data from the DAQ engine and passes it to plotData()
% samples         = get(obj,'UserData');
% [data, time]    = getdata(obj, samples);
% plotData(time,data)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [] = plotData(time, data)
% % plots data on the graph and displays resistance values
% % no averaging occurs on sweep display, but the user can set how many sweeps
% % to use for resistance averaging
% global wc
% 
% channel = wc.control.amplifier.Index;
% data    = data(:,channel);
% time    = (time(:) - time(1)) .* 1000;
% plot(time, data, 'Parent', wc.sealtest.handles.axes);
% 
% [Rt, Rs, Ri]       = calculateResistance(data, wc.sealtest.pulse);
% wc.sealtest.resist = cat(1,wc.sealtest.resist,[Rt Rs Ri]);
% if size(wc.sealtest.resist,1) >= wc.sealtest.n_sweeps
%     r = mean(wc.sealtest.resist,1);
%     wc.sealtest.resist = [];
%     SetUIParam(me,'ri','String',sprintf('%4.2f',r(3)));
%     SetUIParam(me,'rs','String',sprintf('%4.2f',r(2)));
%     SetUIParam(me,'rt','String',sprintf('%4.2f',r(1)));
%     SetUIParam(me,'gain','String',num2str(get(wc.control.amplifier,'UnitsRange')));
%     
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% function [Rt, Rs, Ri] = calculateResistance(data, Vpulse)
% % calculates the input and series resistance from the first column of data
% % the transient should occur at the maximum.
% % units are in mV/pA = MOhm.
% % This function is annoying b/c dividing is really prone to error propagation,\
% % and the noise can often overwhelm the transient, leading to mis-estimation of
% % a lot of different things.
% d           = data(:,1);
% len         = length(data);
% [y, start]  = max(d);
% [y, finish] = min(d);
% if (start < 21 | start > finish | finish > (len-11))
%     [start, finish] = pulseTimes;
% end
% baseline    = mean(d(10:start-10));
% It          = (d(start) - baseline);
% Is          = (d(start+10) - baseline);
% Ii          = (d(finish-20) - baseline);
% [Rt, Rs, Ri] = deal(Inf);
% if (It ~= 0)
%     Rt = Vpulse./It;
% end
% if (Is ~= 0)
%     Rs = Vpulse./Is;
% end
% if (Ii ~= 0)
%     Ri = Vpulse./Ii;
% end