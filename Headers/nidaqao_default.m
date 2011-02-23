function props  = nidaqao_default()
%
% NIDAQAO_DEFAULT Returns default properties for nidaq analog output objects.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

props   = struct('OutOfDataMode','DefaultValue',...
                 'TriggerType','Manual',...
                 'SampleRate', 1000);