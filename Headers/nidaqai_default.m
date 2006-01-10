function props  = nidaqai_default()
%
% NIDAQAI_DEFAULT Returns default properties for nidaq analog input objects.
%
% $Id: nidaqai_default.m,v 1.1 2006/01/10 20:59:51 meliza Exp $

props   = struct('InputType','SingleEnded',...
                 'SampleRate', 10000);