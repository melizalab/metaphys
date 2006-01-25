function s = waveformevent_struct(varargin)
%
% WAVEFORMEVENT_STRUCT Returns a waveform event structure
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
% Fields:
%   Required:
%       .onset - Nx1 array of onset times, or NxM array of inputs to
%                onset_func
%       .ampl  - Nx1 array of onset times, or NxM array of inputs to
%                ampl_func
%       .dur   - Nx1 array of onset times, or NxM array of inputs to
%                dur_func
%       .cycle_mode     - {'single'}, 'multi', 'random', 'shuffle'
%
%   Optional:
%       .onset_func - function handle that takes M parameters as input and
%                     returns a single onset time (in ms)
%       .ampl_func  - function handle that takes M parameters as input and
%                     returns a single amplitude value (in channel units)
%       .dur_func   - function handle that takes M parameters as input and
%                     returns a single duration time (in ms)
%       .user_func    - function handle that can be used to convert the
%                       onset, amplitude, duration, and user parameters
%                       into an actual waveform. The default is a step
%                       function, but if more complex stimulation is
%                       necessary, this can be any arbitrary function with
%                       the signature:
%
%                       X = @user_func(T, X, onset, ampl, dur)
%
%                       If more than 3 parameters are necessary for this
%                       function, keep in mind that <onset> is actually the
%                       output of @onset_func(onset), which can be any
%                       value whatsoever.
%
% $Id: waveformevent_struct.m,v 1.1 2006/01/26 01:21:30 meliza Exp $

fields  = {'onset', 'ampl', 'dur', 'cycle_mode',...
    'onset_func', 'ampl_func', 'dur_func',...
    'user_func'};
C       = {[], [], [], 'single', [], [], [], []};
req     = 3;


s       = StructConstruct(fields, C, req, varargin);