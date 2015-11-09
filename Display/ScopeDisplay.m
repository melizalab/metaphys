function varargout = ScopeDisplay(action, varargin)
%
% SCOPEDISPLAY Display module for plotting data continously.
%
% SCOPEDISPLAY is used for plotting continuously acquired data. The
% timestamp on this data should be monotonically increasing from the start
% trigger time, so placing new data in relation to old data on the scope is
% not a problem. However, the display will wrap around when the time
% variable reaches the end of the limits of the axes, at which point it
% should replace data at the beginning of the axes.
%
% fig = SCOPEDISPLAY('init', instrument)
% SCOPEDISPLAY('clear', [sweeplength])
% SCOPEDISPLAY('destroy')
%
% See also: SWEEPDISPLAY
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

switch lower(action)
    case 'init'
        instrument  = varargin{1};
        varargout{1} = initFigure(instrument);
        AddSubscriber(mfilename, instrument, @plotData)
    case 'clear'
        ax      = getAxes;
        kids    = get(ax,'children');
        if iscell(kids)
            kids    = cell2mat(kids);
        end
        delete(findobj(kids,'HandleVisibility','on'));
        set(ax,'UserData',0)
        if nargin > 1
            sweeplength = varargin{1};
            set(ax, 'xlim', [0 sweeplength]);
        end
    case 'destroy'
        destroyModule
    otherwise
        error('METAPHYS:protocol:noSuchAction',...
            'No such action %s supported by protocol %s',...
            action, mfilename)
end

function [ax tag figure] = getAxes()
% Returns the current axes and their tags
figure  = GetUIHandle(mfilename, mfilename);
ax      = findobj(figure, 'type', 'axes');
tag     = get(ax, 'tag');


% This function plots the data only and does not initialize the subplots.

function [] = plotData(packet)
% Plots data in a packet
[ax tag fig]    = getAxes;
selmode         = get(fig, 'Pointer');
xlim            = get(ax(1), 'xlim');

% sprintf('Packet.Channels man!');
% Lets look and see how packet.channels look like:
% Command:  packet.channels
% Output:  'I_channel1'
%          'V_channel1'
%          'I_channel2'
%          'V_channel2'

for i = 1:length(packet.channels)
    ind     = strmatch(packet.channels{i}, tag);
    if ~isempty(ind)
        % rearrange time and data
        c       = get(ax(ind), 'children');
        T       = get(c,'xdata')';
        Y       = get(c,'ydata')';
        time    = packet.time - packet.time(1);
        lastpt  = get(ax(ind), 'userdata');
        time        = lastpt + time;
        lastpt      = time(end);
        % see if anything is past the limits
        over        = time >= xlim(2);
        [T,Y]       = replacechunk(T, Y, time(~over), packet.data(~over,i));
        if any(over)
            t_over      = time(over);
            t_over      = t_over - t_over(1);
            lastpt      = t_over(end);
            [T Y]       = replacechunk(T, Y, t_over, packet.data(over,i));
        end
        % axis limits depend on if the user has a tool selected
        plot(ax(ind), T, Y);
        set(ax(ind), 'xlim', xlim)
        set(ax(ind), 'userdata', lastpt)
        
        ylabel(ax(ind),...
            sprintf('%s (%s)', packet.channels{i}, packet.units{i}));
    end
end

function [X, Y] = replacechunk(X, Y, newX, newY)
% replaces overlapping times
% times must be monotonic
if ~isempty(newX) && ~isempty(newY)
    below           = (X < newX(1));
    above           = (X > newX(end));
    % insert a NaN to break the display line
    newY(end,:)     = repmat(NaN, 1, size(newY,2));
    X               = cat(1, X(below), newX, X(above));
    Y               = cat(1, Y(below,:), newY, Y(above,:));
end

function [] = buttonHandler(varargin)
% Handles button presses
SCALE   = 0.8;
[ax t fig]      = getAxes;
tag     = get(varargin{1}, 'tag');
xlim    = get(ax(1), 'xlim');
switch tag
    case 'axes_shrink'
        set(ax, 'xlim', [0, xlim(2) * SCALE])
    case 'axes_grow'
        set(ax, 'xlim', [0, xlim(2) / SCALE])
    case 'axes_yshrink'
        ax      = get(varargin{1},'userdata');
        ylim    = get(ax,'ylim');
        cent    = ylim(1) + diff(ylim)/2;
        range   = diff(ylim) .* SCALE / 2;
        set(ax, 'ylim', [cent - range, cent + range]);
    case 'axes_ygrow'
        ax      = get(varargin{1},'userdata');
        ylim    = get(ax,'ylim');
        cent    = ylim(1) + diff(ylim)/2;
        range   = diff(ylim) ./ SCALE / 2;
        set(ax, 'ylim', [cent - range, cent + range]);
end

function [] = axesHandler(obj, event)
% resets the axis to auto ylim
% this function only gets called if the window has no callbacks, so if the
% user has a tool selected there is no effect
click    = get(obj, 'selectiontype');
ax       = get(obj, 'currentaxes');
if strcmpi(click,'alt') && ishandle(ax)
    set(ax,'ylimmode','auto');
end

function [f] = initFigure(instrument)

% Initializes the figure
f   = FindFigure(mfilename);
if ~isempty(f)
    delete(f);
end
    
f   = OpenFigure(mfilename,'units','normalized',...
    'position',[0.0031    0.2031    0.8070    0.585],...
    'toolbar','figure',...
    'UserData', instrument,...
    'WindowButtonDownFcn', @axesHandler, ...
    'DeleteFcn',@destroyModule);

[c,p,s]   = GetInstrumentChannelNames(instrument,'output');
% Execution of the command above returns the following:
% c = 
%    'I_channel1'    'V_channel1'    'I_channel2'    'V_channel2'
% p = 
%    [1x33 char]    [1x33 char]    [1x33 char]    [1x33 char]
% s = 
%    'I_channel1 (pA)'    'V_channel1 (mV)'    'I_channel2 (pA)'    'V_channel2 (mV)'


nplots = 3;

totalh  = 0.85;
gap = 0.01;
y = 0.98;
ax = zeros(1,2);
height1 = totalh/3;
height2 = totalh-height1;

ax(1) = subplot(nplots, 1, 1);
set(ax(1),'position',[0.057, y-height1, 0.9 height1],...
    'XGrid','On','YGrid','On','Box','On',...
    'nextplot','replacechildren',...
    'tag',c{1},'xlim',[0 2000],'userdata',0);
uicontrol(f, 'style','pushbutton','String','+',...
    'units','normalized',...
    'position', [0.97 y-(height1 * 0.5) 0.02 0.04],...
    'tag','axes_ygrow',...
    'userdata',ax(1),...
    'callback',@buttonHandler);
uicontrol(f, 'style','pushbutton','String','-',...
    'units','normalized',...
    'position', [0.97 y-(height1 * 0.5)-0.05 0.02 0.04],...
    'tag','axes_yshrink',...
    'userdata',ax(1),...
    'callback',@buttonHandler);

yl = ylabel('I_{channel_1} (pA)');
set(yl, 'fontweight', 'bold', 'fontsize', 14);
y   = y-height1-gap;


ax(2) = subplot(nplots, 1, 2:3);
set(ax(2),'position',[0.057, y-height2, 0.9 height2],...
    'XGrid','On','YGrid','On','Box','On',...
    'nextplot','replacechildren',...
    'tag',c{2},'xlim',[0 2000],'userdata',0);
uicontrol(f, 'style','pushbutton','String','+',...
    'units','normalized',...
    'position', [0.97 y-(height2 * 0.5) 0.02 0.04],...
    'tag','axes_ygrow',...
    'userdata',ax(2),...
    'callback',@buttonHandler);
uicontrol(f, 'style','pushbutton','String','-',...
    'units','normalized',...
    'position', [0.97 y-(height2 * 0.5)-0.05 0.02 0.04],...
    'tag','axes_yshrink',...
    'userdata',ax(2),...
    'callback',@buttonHandler);

yl = ylabel('V_{channel_1} (mV)');
set(yl, 'fontweight', 'bold', 'fontsize', 14);
% ylabel(s{2});

set(ax(1:end-1), 'xticklabel', [])
xl = xlabel(ax(end),'Time (ms)');
set(xl, 'fontweight', 'bold', 'fontsize', 14);

linkaxes(ax, 'x');
% add buttons for stretching and shrinking axes
uicontrol(f, 'style', 'pushbutton', 'String', '-',...
    'tag','axes_shrink','callback',@buttonHandler,...
    'units','normalized','position',[.495 gap 0.03 0.04])
uicontrol(f, 'style', 'pushbutton', 'String', '+',...
    'tag','axes_grow','callback',@buttonHandler,...
    'units','normalized','position',[.525 gap 0.03 0.04])
    


function [] = destroyModule(varargin)
DeleteSubscriber(mfilename);
f   = FindFigure(mfilename);
if ~isempty(f)
    delete(f);
end
