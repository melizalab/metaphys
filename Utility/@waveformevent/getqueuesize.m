function ntrials    = getqueuesize(obj)
%
% GETQUEUESIZE Returns the size of the parameter queue
%
% GETQUEUESIZE(event) returns the number of trials in the queue
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

if isempty(obj.queued_params)
    ntrials = 0;
else
    ntrials = size(obj.queued_params{1},1);
end