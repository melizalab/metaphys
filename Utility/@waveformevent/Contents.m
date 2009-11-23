% @WAVEFORMEVENT
%
% A waveform event, generally speaking, defines a function for modifying
% a signal. A waveform is made up of a collection of waveform events,
% applied one after another to a flat signal.  Each event has a set of
% parameters -- onset, duration, and amplitude -- that define its effect on
% the signal.
%
% All events must have at least scalar values for each of these parameters.
% The parameters can also take a range of values. One value is picked for
% each trial. In addition to values, each parameter can also be controlled
% by a function.  This function provides a mapping between the parameter
% value and the actual value used during waveform construction.  The
% default function is (x), where x is the value of the parameter during a
% given trial.
%
% For basic events, parameter inputs are Nx1 vectors. For function-controlled
% parameters, parameter inputs may be NxM vectors, where M is the number of
% inputs to the parameter function.
%
% The way in which parameter (inputs) are cycled depends on the value of
% the .cycle_mode field. For 'single', a single cycle based on the shortest
% list of values is used. If other parameters have more values, they are
% ignored. For 'multi', all three parameter values are cycled
% independently. For 'random', on each trial a random value is chosen for
% each parameter.  For 'shuffle', a random value is chosen on each trial,
% but all the possible values are exhausted before being repicked.
%
% See Also: @WAVEFORM
%
% Files
%   applyevent       - Applies the effects of an event on a signal
%   default_function - Returns the default function used for applying events to
%   display          - Display method for waveformevent
%   generatesweep    - Generates a single sweep event from the parameter queue
%   get              - Returns the value of a field of WAVEFORMEVENT
%   geteventlength   - Returns the min and max time that the event will affect
%   getfunc          - Returns the function associated with a parameter
%   getparamrotation - Returns the rotation of parameter values for a
%   getqueuesize     - Returns the size of the parameter queue
%   getvaluerotation - Returns the actual values of the parameters for each
%   isvalid          - Returns true if the waveformevent object is valid (ie will
%   loadobj          - Handles WAVEFORMEVENT objects after loading from disk
%   queuesweeps      - Adds additional parameter values to the parameter queue
%   resetqueue       - Resets the parameter queue for a waveformevent
%   saveobj          - Removes private and transient fields from object before saving
%   set              - Sets values for waveformevent object
%   waveformevent    - Constructor for the waveformeevent class
%
% $Id: Contents.m,v 1.1 2006/01/27 23:46:46 meliza Exp $