function f  = TRANSIENT_FIELDS
%
% TRANSIENT_FIELDS Returns fieldnames that should not be saved to disk.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

f  = {'queued_params', 'queue_pointer'};