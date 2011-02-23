function fhandle = default_function(obj)
%
% DEFAULT_FUNCTION Returns the default function used for applying events to
% signals.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

fhandle = @step_function;
