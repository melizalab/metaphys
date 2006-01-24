function [] = MovieControl(action, varargin)
%
% MOVIECONTROL Controls movie playback on an f21 remote computer
%
% This module is used to control a remote f21 program - connect to a remote
% computer, retrieve display properties and movie file lists, and set up
% the order of movie playback.
%
% MOVIECONTROL('init', remote_host, [remote_port])
% MOVIECONTROL('destroy')
%
% $Id: MovieControl.m,v 1.1 2006/01/24 21:42:15 meliza Exp $

switch lower(action)
    case 'init'
        createFigure
        setController(varargin{:})
        updateFigure
    case 'destroy'
        deleteController
end

function out = me()
out = mfilename;

function [] = createFigure()
% generates the figure
fig     = OpenGuideFigure(mfilename);
InitParam(me,'controller','object')

% add callbacks
h       = GetUIHandle(me, {'remote_host', 'remote_port',...
    'frame_rate_factor', 'sel_object'});
set(h, 'callback', @updateFigure);

h       = GetUIHandle(me, {'movie_add', 'movie_remove',...
    'movie_up', 'movie_down'});
set(h, 'callback', @buttonHandler);
   
function [] = updateFigure(varargin)
% updates values in the figure, especially after controller address has
% changed
if nargin > 0
    tag     = get(varargin{1}, 'tag');
else
    tag     = '';
end
c   = GetParam(me, 'controller');
switch tag
    case {'remote_host', 'remote_port'}
        rh  = GetUIParam(me, 'remote_host');
        rp  = GetUIParam(me, 'remote_port','stringval');
        c   = makecontroller(rh, rp);
    case 'frame_rate_factor'
        v   = GetUIParam(me, 'frame_rate_factor', 'value');
        if ~isempty(c)
            set(c, 'frame_rate_factor', v);
        end
end
if isempty(c) || ~isvalid(c)
    SetUIParam(me,'project_name','Disconnected');
else
    props   = get(c);
    SetUIParam(me,'project_name',props.project_name)
    SetUIParam(me,'video_mode',props.video_mode)
    SetUIParam(me,'time_before_trigger',props.time_before_trigger)
    frates  = props.refresh_rate ./ [1:12];
    frates  = sprintf('%3.4f Hz,',frates);
    frates  = strread(frates, '%s','delimiter',',');
    SetUIParam(me,'frame_rate_factor','string',frates);
    [mov frm] = getmoviefiles(c);
    SetUIParam(me,'movie_files','String',formatmovielist(mov, frm),...
        'UserData', mov);

    if strcmpi(props.project_name,'f21mvx')
        nobj    = getobjectcount(c);
        SetUIParam(me,'num_objects',nobj);
        SetUIParam(me,'sel_object','string',num2str([1:nobj]'),...
            'Enable','On');
        obj     = GetUIParam(me,'sel_object','value') - 1;
        [mov frm]   = getmovielist(c, obj);
        total_time      = getmovietime(c,obj);
    else
        SetUIParam(me,'num_objects',1);
        SetUIParam(me,'sel_object','string','1','Enable','Off');
        [mov frm]   = getmovielist(c);
        total_time      = getmovietime(c);
   end
    SetUIParam(me,'movie_list','String',formatmovielist(mov,frm),...
        'UserData', mov);
    SetUIParam(me,'total_time',total_time);
end

function [] = buttonHandler(varargin)
% handles button presses
c       = GetParam(me,'controller');
if isempty(c) || ~isvalid(c)
    updateFigure
else
    fls     = GetUIParam(me,'movie_files','userdata');
    fls_sel = GetUIParam(me,'movie_files','Value');
    mvs     = GetUIParam(me,'movie_list','userdata');
    mvs_sel = GetUIParam(me,'movie_list','Value');
    mvs_ind = 1:size(mvs,1);
    tag = get(varargin{1}, 'tag');
    switch tag
        case 'movie_add'
            newlist = {mvs{:},fls{fls_sel}}';
            newsel  = size(newlist,1);
        case 'movie_remove'
            newlist = mvs(setdiff(mvs_ind, mvs_sel));
            newsel  = mvs_sel;
        case 'movie_up'
            ind_start = mvs_sel(1) - 2;
            if ind_start == 0, ind_start = []; end
            newind      = mvs_ind(1:ind_start);
            newsel      = size(newind,2) + 1;
            
            newind      = [newind, mvs_sel];
            newind      = [newind setdiff(mvs_ind, newind)];
            
            newlist     = mvs(newind);
            newsel      = newsel:(newsel + length(mvs_sel) - 1);
        case 'movie_down'
            ind_end = mvs_sel(end) + 2;
            if ind_end > mvs_ind(end), ind_end = []; end
            newind    = [mvs_sel, mvs_ind(ind_end:end)];
            newstart  = setdiff(mvs_ind, newind);
            newsel    = size(newstart,2) + 1;
            
            newind    = [newstart newind];
            newlist   = mvs(newind);
            newsel    = newsel:(newsel + length(mvs_sel) - 1);
    end
    prgm    = GetUIParam(me,'project_name');
    if strcmpi(prgm,'f21mvx')
        obj = GetUIParam(me,'sel_object','value') - 1;
        try
            setmovielist(c, obj, newlist);
        catch
            % f21mvx is a bit pickier about the sort of movies we send it
            errordlg('Unable to add movie to list: format mismatch');
            setmovielist(c, obj, mvs);
        end
        [mvs frms] = getmovielist(c, obj);
    else
        setmovielist(c, newlist);
        [mvs frms] = getmovielist(c);
    end
    SetUIParam(me,'movie_list','string',formatmovielist(mvs, frms),...
        'value', newsel, 'userdata', mvs);
end

function out = formatmovielist(names, frames)
out    = [char(names), repmat(' (', size(names,1), 1), num2str(frames),...
        repmat(')', size(names,1), 1)];

    
function [] = setController(varargin)
% sets the values in the remote address and port fields
if nargin > 0
    rh      = varargin{1};
    if nargin > 1
        rp  = varargin{2};
    else
        rp  = 6543;
    end
    SetUIParam(me, 'remote_host', rh);
    SetUIParam(me, 'remote_port', rp);
    makecontroller(rh, rp);
end

function [c] = makecontroller(rh, rp)
c   = f21control(rh, rp);
if isvalid(c)
    SetParam(me, 'controller', c)
else
    InitParam(me, 'controller', 'object')
end

