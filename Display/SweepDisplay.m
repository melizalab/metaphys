function [] = SweepDisplay(action, varargin)
%
% SWEEPDISPLAY Display module for plotting sweeps
%
% SWEEPDISPLAY is used for plotting sweep data. It controls a figure with
% axes - one for each output from an instrument. It creates and manages a
% subscription that allows it to get this data
%
% SWEEPDISPLAY('init', instrument)
% SWEEPDISPLAY('clear')
% SWEEPDISPLAY('destroy')
%
% $Id: SweepDisplay.m,v 1.2 2006/01/21 01:22:29 meliza Exp $

switch lower(action)
    case 'init'
        instrument  = varargin{1};
        initFigure(instrument)
        AddSubscriber(mfilename, instrument, @plotData)
    case 'clear'
        ax      = getAxes;
        kids    = get(ax,'children');
        if iscell(kids)
            kids    = cell2mat(kids);
        end
        delete(findobj(kids,'HandleVisibility','on'));
    case 'destroy'
        destroyModule
    otherwise
        error('METAPHYS:protocol:noSuchAction',...
            'No such action %s supported by protocol %s',...
            action, mfilename)
end

function [ax tag] = getAxes()
% Returns the current axes and their tags
figure  = GetUIHandle(mfilename, mfilename);
ax      = findobj(figure, 'type', 'axes');
tag     = get(ax, 'tag');

function [] = plotData(packet)
% Plots data in a packet
[ax tag]    = getAxes;
for i = 1:length(packet.channels)
    ind     = strmatch(packet.channels{i}, tag);
    if ~isempty(ind)
        plot(ax(ind), packet.time, packet.data(:,i));
        set(ax(ind), 'xlim', [packet.time(1) packet.time(end)])
        ylabel(ax(ind),...
            sprintf('%s (%s)', packet.channels{i}, packet.units{i}));
    end
end


function [] = initFigure(instrument)
% Initializes the figure
f   = FindFigure(mfilename);
if ~isempty(f)
    delete(f);
end
f   = OpenFigure(mfilename,'units','normalized',...
    'position',[0.0031    0.2031    0.7070    0.485],...
    'toolbar','figure',...
    'UserData', instrument,...
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
        'nextplot','replacechildren',...
        'tag',c{i})
    ylabel(s{i})
    y   = y-height-gap;
end
set(ax(1:end-1), 'xticklabel', [])
xlabel(ax(end),'Time (ms)')
linkaxes(ax, 'x');

function [] = destroyModule(varargin)
DeleteSubscriber(mfilename);
f   = FindFigure(mfilename);
if ~isempty(f)
    delete(f);
end
