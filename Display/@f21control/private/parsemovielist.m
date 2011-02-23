function [names, frames] = parsemovielist(C)
%
% PARSEMOVIELIST Parses a movie lists into names and frame counts
%
% [names, frames] = parsemovielist({movies})
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

% results are pairs: <moviename>,<frames>,<moviename2>,<frames2>
nmovies = C{1};
C       = reshape(C(2:end), 2, nmovies);
names   = C(1,:)';
frames  = [C{2,:}]';