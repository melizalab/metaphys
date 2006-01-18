function props  = nidaqao_default()
%
% NIDAQAO_DEFAULT Returns default properties for nidaq analog output objects.
%
% $Id: nidaqao_default.m,v 1.2 2006/01/19 03:15:02 meliza Exp $

props   = struct('OutOfDataMode','DefaultValue',...
                 'TriggerType','Manual',...
                 'SampleRate', 1000);