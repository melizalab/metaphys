function [mpctrl] = mpctrl_default()
%
% MPCTRL_DEFAULT Returns the default values for the MPCTRL global control 
% structure.
%
% $Id: mpctrl_default.m,v 1.1 2006/01/10 20:59:51 meliza Exp $

mpctrl = struct('daq',[],...
                'instrument',[],...
                'defaults',[]);