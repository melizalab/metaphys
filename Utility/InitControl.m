function [] = InitControl()
%
% INITCONTROL Initializes the control structure (mpctrl).
%
% Uses the default values in MPCTRL_DEFAULT.
%
% See also: MPCTRL_DEFAULT
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE
%
global mpctrl

DebugPrint('Initializing control structure.')
mpctrl  = mpctrl_default;
