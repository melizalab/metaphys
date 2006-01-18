% HEADERS
%
% In this directory are two kinds of files, headers and defaults. Header
% files provide empty structures that define a "class". The mfiles should
% be named according to the form <classname>_struct.m.  Defaults also
% return structures, but are generally checked when initializing an object
% or uicontrol. If the default file exists (filenames
% <classname>_default.m), SET() should be called after creating the object.
%
% Files
%   figure_default      - Returns default properties for new figures.
%   instrument_struct   - Header for the instrument structure.
%   mpctrl_default      - Returns the default values for the MPCTRL global control 
%   nidaqai_default     - Returns default properties for nidaq analog input objects.
%   param_struct        - Header for the parameter structure. 
%   paramfigure_default - Returns default properties for new figures.
%   uiparam_default     - Returns default properties for new UIParams
%   channel_default     - Default values for a new channel
%   channel_struct      - Header for the channel structure in control
%   nidaqao_default     - Returns default properties for nidaq analog output objects.
%   packet_struct       - Returns the header for the data packet structure.
%   sealtest_default    - Returns default values for sealtest protocol
%   subscriber_struct   - Returns the header for the subscriber structure
%   telegraph_struct    - Header for the telegraph structure
%
% $Id: Contents.m,v 1.2 2006/01/19 03:15:01 meliza Exp $