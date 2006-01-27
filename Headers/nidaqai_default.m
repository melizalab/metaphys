function props  = nidaqai_default()
%
% NIDAQAI_DEFAULT Returns default properties for nidaq analog input objects.
%
% $Id: nidaqai_default.m,v 1.3 2006/01/27 23:46:33 meliza Exp $

props   = struct('InputType','SingleEnded',...
                 'TriggerType','Manual',...
                 'HwDigitalTriggerSource','PFI6',...
                 'SampleRate', 10000);