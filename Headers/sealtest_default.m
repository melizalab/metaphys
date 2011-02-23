function out  = sealtest_default()
%
% SEALTEST_DEFAULT Returns default values for sealtest protocol
%
% These fieldnames and their values correspond to UIParams in the SEALTEST
% protocol.
%
% See also: SEALTEST
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

out = struct('pulse_amp', 5, ...
             'pulse_len', 40);