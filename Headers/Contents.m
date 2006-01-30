% HEADERS
%
% In this directory are two kinds of files, headers and defaults. Header
% files provide empty structures that define a "class". The mfiles should
% be named according to the form <classname>_struct.m.  Header functions
% should have two signatures: (1) an empty constructor that returns an
% empty header, and (2) at least one constructor that returns a valid
% object.
%
% Defaults also return structures, but are generally checked when
% initializing an object or uicontrol. The functions GETDEFAULT and
% SETOBJECTDEFAULTS use these functions to set default values on newly
% created objects.
%
% Files
%   figure_default       - Returns default properties for new figures.
%   instrument_struct    - Header for the instrument structure.
%   mpctrl_default       - Returns the default values for the MPCTRL global control 
%   nidaqai_default      - Returns default properties for nidaq analog input objects.
%   param_struct         - Header for the parameter structure. 
%   paramfigure_default  - Returns default properties for new figures.
%   uiparam_default      - Returns default properties for new UIParams
%   channel_default      - Default values for a new channel
%   channel_struct       - Header for the channel structure in control
%   nidaqao_default      - Returns default properties for nidaq analog output objects.
%   packet_struct        - Returns the header for the data packet structure.
%   sealtest_default     - Returns default values for sealtest protocol
%   subscriber_struct    - Returns the header for the subscriber structure
%   telegraph_struct     - Header for the telegraph structure
%   episode_default      - Returns default parameters for the EPISODE protocol
%   gapfree_default      - Default parameter values for the GAPFREE protocol
%   moviecontrol_default - Returns default values for the moviecontrol dialog
%   playmovie_default    - Returns default parameters for the PLAYMOVIE protocol
%   r0_struct            - Constructor for the r0 data structure
%   r1_struct            - Constructer for the r1 data structure
%   waveform_struct      - Returns a waveform structure
%   waveformevent_struct - Returns a waveform event structure
%
% $Id: Contents.m,v 1.5 2006/01/30 19:23:11 meliza Exp $
