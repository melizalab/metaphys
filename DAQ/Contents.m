% DAQ
%
% Functions associated with DAQ devices, instruments, channels, and their
% representations in the control structure.
%
% Files
%   AddInstrumentInput          - Adds an input to an instrument. 
%   AddInstrumentOutput         - Adds an output to an instrument. 
%   AddInstrumentTelegraph      - Defines a telegraph channel for an instrument.
%   DeleteDAQ                   - Deletes one or more daq objects from the control structure.
%   DeleteInstrument            - Deletes an instrument from the control structure, and
%   DeleteInstrumentChannel     - Removes an input or output from an instrument in
%   DeleteInstrumentTelegraph   - Removes a telegraph from an instrument. 
%   DigitizerDialog             - Dialogue box for setting up digitization hardware. 
%   GetDAQNames                 - Returns a cell array containing a list of the initialized
%   GetDAQProperty              - Retrieves property value(s) from a DAQ object. 
%   GetDAQPropInfo              - Retrieves property information from a DAQ object. 
%   GetInstrumentChannelNames   - Returns a cell array containing a list of all
%   GetInstrumentNames          - Returns a cell array containing a list of the initialized
%   InitDAQ                     - Initializes data acquisition hardware and stores the associated
%   InitInstrument              - Initializes an instrument in the control structure.
%   IsDAQProperty               - Returns true if a daq object has a property.
%   ResetDAQ                    - Returns a daq device to its initial state. 
%   SetDAQProperty              - Sets property value(s) on a DAQ object. 
%   SetDAQTrigger               - Sets the triggering behavior for one or more data
%   SetInstrumentChannelProps   - Changes properties of an instrument channel. 
%   StopDAQ                     - Stops one or more DAQs from running.
%   UpdateTelegraph             - Reads values from instrument telegraphs and updates the
%   ChannelDialog               - Dialogue box for configuring instrument channels.
%   GetChannelGain              - Returns the gain setting on a channel
%   GetChannelIndices           - Returns the (DAQ) channel indices for all the channels
%   GetChannelSampleRate        - Returns the sampling rate of a channel
%   GetDAQHwChannels            - Returns the available hardware channels on a daq
%   GetDAQTrigger               - Returns information on how the daq is triggered
%   GetDefaultValues            - Returns the default values of the channels on a DAQ
%   GetInstrumentChannelProps   - Changes properties of an instrument channel. 
%   GetInstrumentTelegraphNames - Returns the names of the telegraphs defined
%   InstrumentDialog            - Dialogue box for configuring instruments.
%   NewInstrumentName           - Returns a unique name for a new instrument. 
%   PutInputData                - Preloads values that will go to the instrument's inputs in the
%   RenameInstrument            - renames an instrument in the control structure.
%   ResetDAQOutput              - Returns the output values of a DAQ analogoutput to their
%   SetChannelGain              - Sets the gain of a channel
%   StartContinuous             - Starts a continuous acquisition.
%   StartSweep                  - Initiates data acquisition for a fixed length of time.
%   TelegraphDialog             - Dialogue box for configuring instrument telegraphs.
%   GetCurrentInstrumentName    - Returns the name of the instrument currently
%   GetInstrumentChannel        - Returns the channel object associated with an
%   IsDAQRunning                - Returns true if any daq is currently running
%   PutInputWaveform            - Preloads values from a waveform object into an
%   SetDataStorage              - Sets where data will be stored
%
% $Id: Contents.m,v 1.3 2006/01/27 23:46:19 meliza Exp $
