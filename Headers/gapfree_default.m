function out = gapfree_default()
%
% GAPFREE_DEFAULT Default parameter values for the GAPFREE protocol
%
% $Id: gapfree_default.m,v 1.2 2006/01/30 19:23:12 meliza Exp $

out = struct('instrument',...
    param_struct('Instrument', 'list', 1, {}),...
    'update_rate',...
    param_struct('Update Rate', 'value', 10, [], 'Hz'));