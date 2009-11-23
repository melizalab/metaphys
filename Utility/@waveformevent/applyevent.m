function X  = applyevent(obj, T, X, do_unique)
%
% APPLYEVENT Applies the effects of an event on a signal
%
% APPLYEVENT(event, T, X) returns the signal(s) that result from
% application of the event to the signal(s) defined by T and X. T must be
% an Nx1 vector of time values (in milliseconds). X must be an NxM array.
% The event will be applied to each of the columns in X.
%
% The signal returned will be an NxQ array, where Q is the number of 
% signals that can result from application of the event to the input
% signal(s).  Q can rapidly get quite large when there are a lot of
% parameter combinations in the event (i.e. with 'multi' and 'shuffle'
% cycle modes) or when the event interacts with any variance in the input
% signals (for instance, if two events collide)
%
% APPLYEVENT(event, T, X, 'unique') returns only the unique signals.
%
% See also: 
%
% $Id: applyevent.m,v 1.1 2006/01/26 01:21:32 meliza Exp $

fields  = FIELDS;
params  = cell(size(fields));

[params{:}]     = getvaluerotation(obj);

if isempty(obj.user_func)
    obj.user_func   = default_function(obj);
end

X   = obj.user_func(T, X, params{:});

if nargin > 3 && strcmpi(do_unique, 'unique')
    X   = unique(X','rows')';
end
    
