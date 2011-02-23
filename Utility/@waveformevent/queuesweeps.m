function obj    = queuesweeps(obj, varargin)
%
% QUEUESWEEPS Adds additional parameter values to the parameter queue
%
% event = QUEUESWEEPS(event, [nsweeps]) returns a modified object with new
% values added to the queue. <nsweeps> is ignored unless the cycle_mode of
% the object is 'random', in which case it determines how many new values
% to add to the queue. In other modes the number of values is determined by
% the number of parameters available.
%
% If the dimensions of the parameters returned by GETVALUEROTATION has
% changed since the last call to QUEUESWEEPS the old values will be
% deleted.
%
% If the queue was formerly invalid, the queue pointer is advanced to 1.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

fields          = FIELDS;
nparams         = length(fields);
[params{1:nparams}]     = getvaluerotation(obj, varargin{:});
oldparams       = obj.queued_params;

nval_new        = cellfun('size',params,2);
nval_old        = cellfun('size',oldparams,2);
% we only cat on new arguments if all the parameters have kept their sizes
if all(size(nval_new) == size(nval_old)) && all(nval_new == nval_old)
    for i = 1:length(oldparams)
        params{i}   = cat(1,oldparams{i},params{i});
    end
else
    obj.queue_pointer   = 1;
end

obj.queued_params   = params;
        
