function varargout = SweepDisplay(action, varargin)
%
% SWEEPDISPLAY Display module for plotting sweeps
%
% SWEEPDISPLAY is used for plotting sweep data. It controls a figure with
% axes - one for each output from an instrument. It creates and manages a
% subscription that allows it to get this data.
%
% fig = SWEEPDISPLAY('init', instrument, averageplotnum])
% SWEEPDISPLAY('clear', [sweeplength])    - deletes all non-averaged traces
% SWEEPDISPLAY('clearall', [sweeplength]) - deletes all traces
% SWEEPDISPLAY('destroy')
%
% <averageplotnum> is a vector of integers. For each element in the vector,
% SWEEPDISPLAY will track the last N plots and plot an average sweep. If N
% is Inf, the average will be of all data received after the last
% 'clearall'. Note that averaging only works if episodes are of a fixed
% length; this must be specified when the plot is cleared.
%
% A note on axis limits. If the axes are cleared without setting a sweep
% length, the limits will be reset to their default values. When data is
% plotted, the behavior of the axes will depend on if the user has a tool
% selected in the figure toolbar. If a tool is selected, both axes will be
% held. If no tool is selected, the y axis limits will be automatic, and
% the x axis limits will depend on whether a sweeplength was set when the
% axes were cleared. If no sweeplength was set, x axes limits will be
% automatic; if it was set, they will remain fixed.
%
% Generally this does not matter unless the graph is being updated more
% than once per trigger. If this is the case, it is imperative to specify
% the sweeplength so that the plot does not go off the limits or have to
% reset the limits continually.
%
% $Id: SweepDisplay.m,v 1.5 2006/01/25 22:22:49 meliza Exp $

switch lower(action)
    case 'init'
        instrument  = varargin{1};
        varargout{1} = initFigure(instrument, varargin{2:end});
        AddSubscriber(mfilename, instrument, @plotData)
    case 'clear'
        clearAxes('single',varargin{:});
    case 'clearall'
        clearAxes('all',varargin{:})
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

function [] = plotData(packet)
% Plots data in a packet
[ax tag fig]    = getAxes;
selmode         = get(fig, 'Pointer');

for i = 1:length(packet.channels)
    ind     = strmatch(packet.channels{i}, tag);
    if ~isempty(ind)
        % axis limits depend on if the user has a tool selected
        if strcmpi(selmode, 'arrow')
            if get(gcf,'userdata')
                axmode  = 'holdx';
            else
                axmode  = 'reset';
            end
        else
            axmode  = 'holdall';
        end
        if packet.time(1) == 0
            del     = findobj(get(ax(ind),'children'),'tag','single');
            delete(del)
        end
        h   = plotChannel(axmode, ax(ind), packet.time, packet.data(:,i));
        set(h,'tag','single');
        ylabel(ax(ind),...
            sprintf('%s (%s)', packet.channels{i}, packet.units{i}));
        % handle averging
        if get(gcf,'userdata')
            plotAverages(axmode, ax(ind),...
                    packet.time, packet.data(:,i), packet.message.Type);
        end
    end
end

function [h] = plotChannel(axmode, ax, time, data, varargin)
% plots data on an axis. axmode can be 'holdx', 'holdy', 'holdall', or
% 'reset'. Also takes care of clearing axes of single traces if the time
% variable starts with 0.
xlim    = get(ax, 'XLim');
ylim    = get(ax, 'YLim');
   
h       = plot(ax, time, data, varargin{:});
switch axmode
    case 'holdx'
        set(ax, 'xlim', xlim, 'ylimmode', 'auto');
    case 'holdy'
        set(ax, 'xlimmode', 'auto', 'ylim', ylim);
    case 'holdall'
        set(ax, 'xlim', xlim, 'ylim', ylim);
    case 'reset'
        set(ax, 'xlimmode', 'auto', 'ylimmode', 'auto');
end

function [] = plotAverages(axmode, ax, time, data, packet_type, varargin)
% here's how plotting averages works. In each axis's userdata field is
% stored a 4-field structure array. The fields are: total_repeats, 
% current_repeat, current_data, and mean_data. There is one structure per
% element in the average_len vector that we were initted with. When a
% packet is sent here, it first gets appended to the current_data field (of
% all elements). If packet_type is 'Stop', then current_repeat is
% incremented, and current_data averaged into mean_data. If current_repeat
% is equal to total_repeats, the data is plotted and current_repeat and
% mean_data are cleared. A special case occurs when total_repeats is Inf:
% current_repeat and mean_data are never cleared, and the data is plotted
% after each 'Stop' event.
FUDGE   = 15;
for i = 1:length(ax)
    colors  = get(ax(i),'ColorOrder');
    ud  = get(ax(i), 'UserData');
    if ~isempty(ud) && ~isempty(ud.sweep_length)
            cd  =   ud.current_data;
            cd  =   cat(1,cd,data);
            ud.time           = cat(1,ud.time,time);
            ud.current_data   = cd;
        % we have to detect the end of a sweep. unfortunately, we sometimes
        % wind up with a shortage of samples. so we include a 15 ms fudge
        % factor; hopefully people won't be trying to update much faster
        % than that
        if ud.time(end) >= (ud.sweep_length - FUDGE)
            for j = 1:length(ud)
                md  = ud.stored(j).mean_data;
                cr  = ud.stored(j).current_repeat;
                tr  = ud.stored(j).total_repeats;
                if isempty(md)
                    md  = cd;
                    cr  = 1;
                elseif size(md,1) > size(cd,1)
                    warning('METAPHYS:sweepdisplay:underfullPacket',...
                        'Not enough data received before Stop to average');
                else
                    % weighted average
                    md  = cat(2,md .* cr, cd);
                    cr  = cr + 1;
                    md  = sum(md,2) ./ cr;
                end
                % plot if we're over total_repeats
                if cr >= tr || tr == Inf
                    % delete previous plots
                    h   = findobj(ax(i),'tag',sprintf('avg-%d',tr));
                    delete(h(ishandle(h)));
                    h   = plotChannel(axmode, ax(i), ud.time, md);
                    set(h,'color',colors(mod(size(colors,1)-1,j)+2,:),...
                        'tag',sprintf('avg-%d',tr));
                    
                end
                if cr >= tr
                    cr  = 0;
                    md  = [];
                end
                ud.stored(j)    = struct('total_repeats', tr,...
                                         'current_repeat', cr,...
                                         'mean_data', md);
            end
            ud.time = [];
            ud.current_data = [];
        end
        set(ax(i),'userdata',ud)
    end
end
        


function [] = clearAxes(mode, varargin)
ax      = getAxes;
if length(ax) < 1
    return
end
% find children of the axes
kids    = get(ax,'children');
if iscell(kids)
    kids    = cell2mat(kids);
end
if strcmpi(mode,'all')
    del     = findobj(kids,'HandleVisibility','on');
else
    del     = findobj(kids,'tag','single');
end
delete(del);
% set axis limits and clear data means
if nargin > 1
    sweeplength = varargin{1};
    ud          = get(ax(1),'userdata');
    if ~isempty(ud)
        n_repeats   = [ud.stored.total_repeats];
        ud          = datamean_struct(n_repeats, sweeplength);
    end
    if strcmpi(mode,'all')
        set(ax, 'xlim', [0 sweeplength],...
            'userdata', ud);
    end
    set(gcf,'userdata', true);
else
    set(gcf,'userdata', false);
end


function [f] = initFigure(instrument, n_repeats)
% Initializes the figure

f   = FindFigure(mfilename);
if ~isempty(f)
    delete(f);
end
f   = OpenFigure(mfilename,'units','normalized',...
    'position',[0.0031    0.2031    0.7070    0.485],...
    'toolbar','figure',...
    'DeleteFcn',@destroyModule);

[c,p,s]   = GetInstrumentChannelNames(instrument,'output');
nplots  = length(c);
% The channel plots should be more tightly placed than subplot makes them
totalh  = 0.9;
height  = totalh / nplots;
gap     = 0.01;
y       = 0.98;
for i = 1:nplots
    ax(i) = subplot(nplots, 1, i);
    set(ax(i),'position',[0.1, y-height, 0.89 height],...
        'XGrid','On','YGrid','On','Box','On',...
        'nextplot','add',...
        'tag',c{i},'xlim',[0 1000])
    ylabel(s{i})
    y   = y-height-gap;
end
set(ax(1:end-1), 'xticklabel', [])
xlabel(ax(end),'Time (ms)')
if nargin > 1
    set(ax, 'userdata', datamean_struct(n_repeats));
end
linkaxes(ax, 'x');

function [] = destroyModule(varargin)
DeleteSubscriber(mfilename);
f   = FindFigure(mfilename);
if ~isempty(f)
    delete(f);
end

function S  = datamean_struct(n_repeats, sweeplength)
if nargin < 2
    sweeplength = [];
end
if length(n_repeats) > 1
    n_repeats   = n_repeats(:);
    n_repeats   = mat2cell(n_repeats, ones(size(n_repeats)));
end
S   = struct('time',[],...
             'current_data',[],...
             'sweep_length',sweeplength,...
             'stored',...
             struct('total_repeats',n_repeats,...
                    'current_repeat',0,...
                    'mean_data',[]));