function [frames] = preparemovie(obj)
%
% PREPAREMOVIE Prepares F21 for movie playback; F21 loads all chosen movie
% objects.
%
% frames = PREPAREMOVIE(f21ctrl)
%
% OUTPUTS: the number of frames loaded
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

out = sendrequest(obj, 'prepare');
tok = StrTokenize(out);
if length(tok) > 1 && strcmpi(tok{2},'finished')
    frames  = str2double(tok{3});
else
    error('METAPHYS:f21control:loadMovieFailed',...
        'Prepare movie failed: %s', out)
end