function [X, obj] = generatesweep(obj, T, X)
%
% GENERATESWEEP Generates a single sweep event from the parameter queue
%
% GENERATESWEEP(obj, T, X) returns the signal(s) that result from
% application of the event to the signal(s) defined by T and X. T must be
% an Nx1 vector of time values (in milliseconds). X must be an NxM array.
% The event will be applied to each of the columns in X.
%
% This method works like APPLYEVENT, but uses parameter values stored in the
% object's queue.  Because this method updates the queue properties, it
% must be returned to the calling function; otherwise the queue will not
% advance.
%
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

% see if we have enough data
if (obj.queue_pointer == 0) || (obj.queue_pointer >= getqueuesize(obj))
    obj = queuesweeps(obj);
end

ptr = obj.queue_pointer;
% retrieve the parameters
for i = 1:length(obj.queued_params)
    my_params{i}    = obj.queued_params{i}(ptr,:);
end

if isempty(obj.user_func)
    obj.user_func   = default_function(obj);
end

X   = obj.user_func(T, X, my_params{:});
obj.queue_pointer   = ptr + 1;
