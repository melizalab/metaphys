function [] = starttuning(obj)
%
% STARTTUNING Begins the tuning test. PREPARETUNING must be called first.
%
% STARTTUNING(f21ctrl)
%
% OUTPUTS: none
%
% $Id: starttuning.m,v 1.1 2006/01/24 03:26:10 meliza Exp $

sendcommand(obj, 'do_tuning_test');