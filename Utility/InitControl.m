function [] = InitControl()
%
% INITCONTROL Initializes the control structure (mpctrl).
%
% Uses the default values in MPCTRL_DEFAULT.
%
% See also: MPCTRL_DEFAULT
%
% $Id: InitControl.m,v 1.2 2006/01/30 20:04:57 meliza Exp $
%
global mpctrl

DebugPrint('Initializing control structure.')
mpctrl  = mpctrl_default;
