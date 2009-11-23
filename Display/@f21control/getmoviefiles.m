function [names, frames] = getmoviefiles(obj)
%
% GETMOVIEFILES Returns a list of movie files available to f21
%
% [names, frames] = GETMOVIEFILES(f21ctrl)
%
% $Id: getmoviefiles.m,v 1.1 2006/01/24 03:26:07 meliza Exp $

out = sendrequest(obj, 'sti_get_mv_files');
tok = Cell2Num(StrTokenize(out));
if length(tok) < 3 || strcmpi(tok{2},'failed')
    error('METAPHYS:f21control:commandFailed',...
        'Unable to retrieve movie list: %s', out);
end
% results are pairs: <moviename>,<frames>,<moviename2>,<frames2>
[names, frames] = parsemovielist(tok(3:end));
