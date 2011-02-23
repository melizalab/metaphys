function out = gapfree_default()
%
% GAPFREE_DEFAULT Default parameter values for the GAPFREE protocol
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

out = struct('instrument',...
    param_struct('Instrument', 'list', 1, GetInstrumentNames),...
    'update_rate',...
    param_struct('Update Rate', 'value', 10, [], 'Hz'));