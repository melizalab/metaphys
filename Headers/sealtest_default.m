function out  = sealtest_default()
%
% SEALTEST_DEFAULT Returns default values for sealtest protocol
%
% These fieldnames and their values correspond to UIParams in the SEALTEST
% protocol.
%
% See also: SEALTEST
%
% $Id: sealtest_default.m,v 1.3 2006/01/30 20:04:50 meliza Exp $

out = struct('pulse_amp', 5, ...
             'pulse_len', 40);