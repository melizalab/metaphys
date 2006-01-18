function props  = nidaqai_default()
%
% NIDAQAI_DEFAULT Returns default properties for nidaq analog input objects.
%
% $Id: nidaqai_default.m,v 1.2 2006/01/19 03:15:02 meliza Exp $

props   = struct('InputType','SingleEnded',...
                 'TriggerType','Manual',...
                 'SampleRate', 10000);