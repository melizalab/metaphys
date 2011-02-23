function props  = nidaqai_default()
%
% NIDAQAI_DEFAULT Returns default properties for nidaq analog input objects.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

props   = struct('InputType','SingleEnded',...
                 'TriggerType','Manual',...
                 'HwDigitalTriggerSource','PFI6',...
                 'SampleRate', 10000);