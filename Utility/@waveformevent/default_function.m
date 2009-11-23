function fhandle = default_function(obj)
%
% DEFAULT_FUNCTION Returns the default function used for applying events to
% signals.
%
% $Id: default_function.m,v 1.1 2006/01/26 01:21:32 meliza Exp $

fhandle = @step_function;
