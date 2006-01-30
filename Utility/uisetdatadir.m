function currdir = uisetdatadir(startdir)
% UISETDATADIR A dialog window that fetches a directory; analogous to UIGETFILE.
%
%
%   This function replaces UIGETDIR and has some nice buttons for adding
%   serially numbered data directories. If the user hits OK, the selected
%   directory will be returned. If the user hits Cancel, returns [].
%
%   Adapted from: P. N. Secakusuma, 27/04/98
%   
%   Copyright (c) 1997 by The MathWorks, Inc.
%
%   $Id: uisetdatadir.m,v 1.2 2006/01/31 00:14:24 meliza Exp $

origdir      = pwd;
if nargin > 0
    if exist(startdir,'dir')
        cd(startdir);
    end
end
CB      = @buttonHandler;

   
fig = figure('NumberTitle', 'off', ...
    'MenuBar', 'none', ...
    'Name', 'Get Directory', ...
    'Resize', 'off', ...
    'Color', get(0,'defaultUicontrolBackgroundColor'), ...
    'Position', [700 500 300 250], ...
    'WindowStyle', 'modal', ...
    'CloseRequestFcn', 'set(gcf, ''Userdata'', ''Cancel'')', ...
    'Tag', 'GetDirectoryWindow');

hedit = uicontrol('Style', 'Edit', ...
    'String', pwd, ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', 'w', ...
    'Position', [10 220 195  20], ...
    'Tag', 'PWDText', ...
    'ToolTipString', 'Present working directory');

hlist = uicontrol('Style', 'Listbox', ...
    'String', getdirectories, ...
    'BackgroundColor', 'w', ...
    'Position', [10  40 195 160], ...
    'Callback', {CB, 'choose'}, ...
    'Max', 1, ...
    'ToolTipString', 'History of current directories', ...
    'Tag', 'DirectoryContentListbox');

htxt1 = uicontrol('Style', 'Text', ...
    'String', ['Choice:  ', pwd], ...
    'HorizontalAlignment', 'left', ...
    'FontWeight', 'bold', ...
    'Position', [10  10 280 20], ...
    'Tag', 'ChosenDirectoryText');

hbut = uicontrol('Style','pushbutton',...
    'String','New FP',...
    'Callback',{CB 'create_dir' 'fp'},...
    'Position',[215 165 80 25]);

hbut = uicontrol('Style','pushbutton',...
    'String','New Cell',...
    'Callback',{CB 'create_dir' 'cell'},...
    'Position',[215 140 80 25]);


hbut = uicontrol('Style','pushbutton',...
    'String','New Directory',...
    'Callback',{CB 'create_dir'},...
    'Position',[215 115 80 25]);

hbut1 = uicontrol('Style', 'Pushbutton', ...
    'String', 'Select', ...
    'Callback', {CB 'select'}, ...
    'Position', [215  90  80  25]);

hbut2 = uicontrol('Style', 'Pushbutton', ...
    'String', 'Cancel', ...
    'Callback', {CB 'cancel'}, ...
    'Position', [215  65  80  25]);

drawnow;

waitfor(fig, 'Userdata');

switch get(fig, 'Userdata'),
    case 'OK',
        hlist_val = get(hlist, 'Value');
        hlist_str = get(hlist, 'String');
        cd(fullfile(pwd, hlist_str{hlist_val}));
        currdir = pwd;
    case 'Cancel',
        currdir = [];
end
cd(origdir)
delete(fig);


function [] = buttonHandler(obj, event, varargin)

switch varargin{1},
    case 'choose',
        if strcmp(get(gcf, 'SelectionType'), 'open'),
            hfig  = findobj('Tag', 'GetDirectoryWindow');
            hlist = findobj(hfig, 'Tag', 'DirectoryContentListbox');
            hedit = findobj(hfig, 'Tag', 'PWDText');
            htxt1 = findobj(gcf, 'Tag', 'ChosenDirectoryText');

            hlist_val = get(hlist, 'Value');
            hlist_str = get(hlist, 'String');
            hlist_dir = hlist_str{hlist_val};

            cd([pwd, '\', hlist_dir]);
            DirList = dir;
            DirName = { DirList.name }';
            finddir = find(cat(1, DirList.isdir));
            DirName = DirName(finddir);

            set(hlist, 'String', DirName, ...
                'Value', 1);
            set(hedit, 'String', pwd);

            hlist_val = get(hlist, 'Value');
            hlist_str = get(hlist, 'String');
            ChosenDir = strrep([pwd, '\', hlist_str{hlist_val}], '\\', '\');

            set(htxt1, 'String', ['Choice:  ', ChosenDir]);
        else
            hlist = findobj(gcf, 'Tag', 'DirectoryContentListbox');
            htxt1 = findobj(gcf, 'Tag', 'ChosenDirectoryText');

            hlist_val = get(hlist, 'Value');
            hlist_str = get(hlist, 'String');
            ChosenDir = strrep([pwd, '\', hlist_str{hlist_val}], '\\', '\');

            set(htxt1, 'String', ['Choice:  ', ChosenDir]);
        end
    case 'select',
        set(gcf, 'Userdata', 'OK');
    case 'cancel',
        set(gcf, 'Userdata', 'Cancel');
    case 'create_dir'
        if nargin > 3
            pref        = varargin{2};
            dirnames    = getdirectories;
            m           = strmatch(pref, dirnames);
            if isempty(m)
                lastser = 0;
            else
                dirnames    = sort(dirnames(m));
                last        = dirnames{end};
                lastser     = sscanf(last,[pref '%d']);
                if isempty(lastser)
                    lastser = 0;
                end
            end
            pref    = sprintf('%s%03.0f', pref, lastser + 1);
            s       = mkdir(pref);
        else
            a = inputdlg('New directory name:','Create Directory',1,{'New Directory'});
            if ~isempty(a)
                pref    = a{1};
                s = mkdir(pref);
            end
        end
        t   = findobj(gcf,'tag','DirectoryContentListbox');
        d   = getdirectories;
        m   = strmatch(pref, d);
        set(t(1),'String',d);        
        if ~isempty(m)
            set(t(1),'Value',m);
        end

end


function dirnames = getdirectories()
% returns the directories in the current directory
dirlist = dir;
dirnames = { dirlist.name }';
finddir = find(cat(1, dirlist.isdir));
dirnames = dirnames(finddir);