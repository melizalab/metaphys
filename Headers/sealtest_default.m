function out  = sealtest_default()
%
% SEALTEST_DEFAULT Returns default values for sealtest protocol
%
% These fieldnames and their values correspond to UIParams in the SEALTEST
% protocol.
%
% See Also: SEALTEST
%
% $Id: sealtest_default.m,v 1.2 2006/01/19 03:15:02 meliza Exp $

out = struct('pulse_amp', 5, ...
             'pulse_len', 40);