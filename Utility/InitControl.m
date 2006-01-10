function [] = InitControl()
%
% INITCONTROL Initializes the control structure (mpctrl).
%
% Uses the default values in MPCTRL_DEFAULT.
%
% See Also: MPCTRL_DEFAULT
%
% $Id: InitControl.m,v 1.1 2006/01/10 20:59:52 meliza Exp $
%
global mpctrl

DebugPrint('Initializing control structure.')
mpctrl  = mpctrl_default;
