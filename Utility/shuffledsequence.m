function seq = shuffledsequence(N, M)
%
% SHUFFLEDSEQUENCE Generates a shuffled sequence
%
% SHUFFLEDSEQUENCE(N) returns the column vector 1:N, shuffled.
% SHUFFLEDSEQUENCE(N,M) returns an NxM array, with each column being a
%                       shuffled sequence from 1:N
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if nargin < 2
    M   = 1;
end

seq = zeros([N M]);
% I don't see any way to do this except looping
for i = 1:M
    seq(:,i)    = randperm(N)';
end