% @WAVEFORM
%
% A waveform is a collection of waveformevent objects. Each of these
% objects represents a transformation of a signal whose parameters can vary
% from trial to trial. The WAVEFORM can be associated with multiple
% channels, each of which can have any number of events associated with it.
%
%
% Files
%   addchannel      - Adds a channel to the waveform object
%   addevent        - Adds an event to a waveform object
%   char            - Casts a WAVEFORM to a character event
%   display         - Display method for WAVEFORM class
%   getchannelcount - Returns the number of channels defined on the waveform
%   getchannelnames - Returns a cell array with the names of defined channels
%   geteventcount   - Returns the number of events defined on a channel
%   getevents       - Returns the waveformevent objects stored under a channel
%   isempty         - Returns true if the waveform has no channels defined
%   removechannel   - Returns a modified waveform object after deleting a channel
%   removeevent     - Removes an event from a waveform object
%   resetqueues     - Resets the queues of all the events in the waveform object
%   setevent        - Replaces an waveformevent object with a different one
%   transformsignal - Applies the waveform to a signal
%   waveform        - Constructor for the waveform class
%
% $Id: Contents.m,v 1.1 2006/01/27 23:46:45 meliza Exp $