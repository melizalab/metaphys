function out = gapfree_default()
%
% GAPFREE_DEFAULT Default parameter values for the GAPFREE protocol
%
% $Id: gapfree_default.m,v 1.3 2006/01/31 17:21:02 meliza Exp $

out = struct('instrument',...
    param_struct('Instrument', 'list', 1, GetInstrumentNames),...
    'update_rate',...
    param_struct('Update Rate', 'value', 10, [], 'Hz'));