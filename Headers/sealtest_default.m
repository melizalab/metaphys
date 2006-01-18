function out  = sealtest_defaults()
%
% SEALTEST_DEFAULTS Returns default values for sealtest protocol
%
% These fieldnames and their values correspond to UIParams in the SEALTEST
% protocol.
%
% See Also: SEALTEST
%
% $Id: sealtest_default.m,v 1.1 2006/01/18 19:01:09 meliza Exp $

out = struct('pulse_amp', 5, ...
             'pulse_len', 40);