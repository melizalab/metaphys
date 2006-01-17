function props  = nidaqao_default()
%
% NIDAQAO_DEFAULT Returns default properties for nidaq analog output objects.
%
% $Id: nidaqao_default.m,v 1.1 2006/01/17 20:22:11 meliza Exp $

props   = struct('OutOfDataMode','DefaultValue',...
                 'SampleRate', 1000);