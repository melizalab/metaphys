function [mpctrl] = mpctrl_default()
%
% MPCTRL_DEFAULT Returns the default values for the MPCTRL global control 
% structure.
%
% The control structure is structured as follows:
%
%   .daq    - contains structures with fieldnames of the daq objects
%   .daq.(daqname):
%       .obj           - DAQ object
%       .name          - DAQ name
%       .type          - 'analog input', 'analog output', or 'digital io'
%       .constructor   - constructor for DAQ object
%       .initial_props - initial properties of daq object
%   .instrument - contains structures with fieldnames of instruments
%   .instrument.(instrumentname):
%       .name       - name of the instrument (should be same as fieldname)
%       .type       - type of the instrument (not currently used)
%       .channels   - contains structures with fieldnames of instruments
%       .channels.(channelname):
%           .obj    - the channel object
%           .name   - the channel name
%           .daq    - the name of the associated daq
%           .type   - 'input' or 'output'
%       .telegraphs - named structure defining telegraphs
%       .telegraphs.(telegraphname):
%           .obj        - the input object (channel or matlab object)
%           .checkfn    - function handle that checks the telegraph values
%           .updfn      - function handle that updates the instrument
%           .output     - arguments that define the output of the telegraph
%    .subscriber - contains subscription structures (SUBSCRIBER_STRUCT)
%    .globals    - contains global variables
%       
%    .defaults  - contains defaults that are accessible through GETDEFAULTS
%    .(modulename)  - storage for modules currently in use
%
%  See Also: SUBSCRIBER_STRUCT, INSTRUMENT_STRUCT, CHANNEL_STRUCT,
%  TELEGRAPH_STRUCT
%           
%
% $Id: mpctrl_default.m,v 1.6 2006/01/25 17:49:28 meliza Exp $

mpctrl = struct('daq',[],...
                'instrument',[],...
                'subscriber',[],...
                'globals',[],...
                'defaults',[]);