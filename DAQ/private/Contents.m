%
% DAQ/PRIVATE
%
% Private functions for accessing DAQ and instrument objects and
% structures.
%
% Files
%   AddTelegraph            - Adds a telegraph to an instrument.
%   DeleteTelegraph         - Deletes a telegraph from an instrument, along with any
%   GetDAQ                  - Returns the DAQ objects referred to by their tags. 
%   GetDAQStruct            - Returns the DAQ structs referred to by their tags. 
%   GetInstrument           - Returns the instrument structures referred to by their
%   GetInstrumentChannel    - Returns the channel object associated with an
%   AddChannel              - Adds a channel to the instrument structure.
%   DeleteChannel           - Deletes a channel from the control structure
%   GetChannelStruct        - Returns the channel structure associated with an
%   GetChannelType          - Returns a channel's type.
%   GetTelegraph            - Returns the telgraph control structure for an instrument.
%   RenameInstrumentChannel - Renames a channel in the instrument structure
%   StartDAQ                - Initiates data acquisition.
%
% $Id: Contents.m,v 1.2 2006/01/19 03:15:00 meliza Exp $