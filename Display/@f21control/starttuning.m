function [] = starttuning(obj)
%
% STARTTUNING Begins the tuning test. PREPARETUNING must be called first.
%
% STARTTUNING(f21ctrl)
%
% OUTPUTS: none
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

sendcommand(obj, 'do_tuning_test');