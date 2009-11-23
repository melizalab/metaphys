function ntrials    = getqueuesize(obj)
%
% GETQUEUESIZE Returns the size of the parameter queue
%
% GETQUEUESIZE(event) returns the number of trials in the queue
%
% $Id: getqueuesize.m,v 1.1 2006/01/27 00:40:10 meliza Exp $

if isempty(obj.queued_params)
    ntrials = 0;
else
    ntrials = size(obj.queued_params{1},1);
end