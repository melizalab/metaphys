function f  = TRANSIENT_FIELDS
%
% TRANSIENT_FIELDS Returns fieldnames that should not be saved to disk.
%
% $Id: TRANSIENT_FIELDS.m,v 1.1 2006/01/27 00:40:12 meliza Exp $

f  = {'queued_params', 'queue_pointer'};