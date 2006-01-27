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
%   AddChannel              - Adds a channel to the instrument structure.
%   DeleteChannel           - Deletes a channel from the control structure
%   GetChannelStruct        - Returns the channel structure associated with an
%   GetChannelType          - Returns a channel's type.
%   GetTelegraph            - Returns the telgraph control structure for an instrument.
%   RenameInstrumentChannel - Renames a channel in the instrument structure
%   StartDAQ                - Initiates data acquisition.
%   MatWriter               - Collects data packets and writes them to disk as a matfile when
%   TriggerDAQ              - Triggers daq acquisition
%
% $Id: Contents.m,v 1.3 2006/01/27 23:46:29 meliza Exp $
