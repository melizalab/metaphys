% DAQ
%
% Files
%   AddInstrumentInput        - Adds an input to an instrument. 
%   AddInstrumentOutput       - Adds an output to an instrument. 
%   AddInstrumentTelegraph    - Defines a telegraph channel for an instrument.
%   DeleteDAQ                 - Deletes one or more daq objects from the control structure.
%   DeleteInstrument          - Deletes an instrument from the control structure, and
%   DeleteInstrumentChannel   - Removes an input or output from an instrument in
%   DeleteInstrumentTelegraph - Removes a telegraph from an instrument. 
%   DigitizerDialog           - Dialogue box for setting up digitization hardware. 
%   GetDAQNames               - Returns a cell array containing a list of the initialized
%   GetDAQProperty            - Retrieves property value(s) from a DAQ object. 
%   GetDAQPropInfo            - Retrieves property information from a DAQ object. 
%   GetInstrumentChannelNames - Returns a cell array containing a list of all
%   GetInstrumentNames        - Returns a cell array containing a list of the initialized
%   InitDAQ                   - Initializes data acquisition hardware and stores the associated
%   InitInstrument            - Initializes an instrument in the control structure.
%   IsDAQProperty             - Returns true if a daq object has a property.
%   ResetDAQ                  - Returns a daq device to its initial state. 
%   SetDAQProperty            - Sets property value(s) on a DAQ object. 
%   SetDAQTrigger             - Sets the triggering behavior for one or more data
%   SetInstrumentChannelProps - Changes properties of an instrument channel. 
%   StartDAQ                  - Starts one or more DAQs running.
%   StopDAQ                   - Stops one or more DAQs from running.
%   UpdateTelegraph           - Reads values from instrument telegraphs and updates the
