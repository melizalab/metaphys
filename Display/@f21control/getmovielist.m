function [names, frames] = getmovielist(obj, display_object)
%
% GETMOVIELIST Gets the movie list for an f21 object
%
% If the remote program is f21mv:
% [names, frames] = GETMOVIELIST(obj)
%
% If the remote program is f21mvx
% [names, frames] = GETMOVIELIST(obj, display_object)
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

remote  = get(obj, 'project_name');
switch lower(remote)
    case 'f21mv'
        error(nargchk(1,1,nargin,'struct'))
        out     = sendrequest(obj, 'sti_get_mv_list');
        tok     = StrTokenize(out);
    case 'f21mvx'
        error(nargchk(2,2,nargin,'struct'))
        out     = sendrequest(obj, 'sti_get_movie_list_2', display_object);
        tok     = StrTokenize(out);
        tok     = tok([1,2,4:end]);
end

if strcmpi(tok{2},'failed')
    error('METAPHYS:f21control:commandFailed',...
        'Failed to retrieve movie list from f21: %s', out);
end
[names, frames] = parsemovielist(Cell2Num(tok(3:end)));
