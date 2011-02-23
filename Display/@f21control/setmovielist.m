function [] = setmovielist(obj, varargin)
%
% SETMOVIELIST Sets the movie list for an f21 object
%
% If the remote program is f21mv:
% SETMOVIELIST(obj, {movie_names})
%
% If the remote program is f21mvx:
% SETMOVIELIST(obj, display_object, {movie_names})
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

remote  = get(obj, 'project_name');
switch lower(remote)
    case 'f21mv'
        error(nargchk(2,2,nargin,'struct'))
        movies  = varargin{1};
        args    = sprintf('%d%s',length(movies), sprintf(',%s', movies{:}));
        out     = sendrequest(obj, 'sti_movie_list', args);
    case 'f21mvx'
        error(nargchk(3,3,nargin,'struct'))
        obj_ind = varargin{1};
        movies  = varargin{2};
        args    = sprintf('%d,%d%s', obj_ind, length(movies),...
            sprintf(',%s', movies{:}));
        out     = sendrequest(obj, 'sti_movie_list_2', args);
end

tok     = StrTokenize(out);
if strcmpi(tok{2},'failed')
    error('METAPHYS:f21control:commandFailed',...
        'Failed to send movie list to f21: %s', out);
end
DebugPrint('Set movie list on remote f21.');