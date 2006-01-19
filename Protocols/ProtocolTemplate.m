function [] = ProtocolTemplate(action)
%
% PROTOCOLTEMPLATE A protocol that does nothing except provide an example
% for writing more functional ones.
%
%
% A protocol needs to respond to certain actions, which are passed as
% string arguments by the calling function. The
% minimum set of arguments are 'init', 'start', 'record', and 'stop', which
% are called when the user clicks the Init, Play, Record, or Stop buttons,
% respectively.
% 
% Aside from responding to these actions, the protocol can operate however
% it likes. If the user is expected to change parameters, it may pay,
% however, to use the PARAMFIGURE function to create a figure that will
% present the relevant parameters to the user.  This figure is created with
% callbacks that ensure that the control structure is updated whenever
% the user changes something, so that the GETPARAM function can be used to
% retrieve those parameters whether or not the parameter window is still
% open.
% 
% Data is sent to the DAQ system using the PUTINPUTDATA function. Single
% acquisition sweeps can be initiated with the STARTSWEEP function, whereas
% if an indefinite amount of data needs to be acquired, the STARTCONTINUOUS
% function should be used.  To retrieve data from these acquisitions,
% create a subscription to an instrument using the ADDSUBSCRIPTION
% function.  Whenever the DAQ system returns data, that data will be
% packaged and sent to the subscriber.
%
% $Id: ProtocolTemplate.m,v 1.1 2006/01/20 02:03:15 meliza Exp $

% The main function generally only parses the action, which is how external
% functions (such as the calling function) control its behavior.
switch lower(action)
    case 'init'
        % The 'init' action is called by the Init button. It should
        % initialize the protocol's parameters and any display windows.
        % Generally it is not necessary or advisable to set up the hardware
        % at this stage, since this will be done on protocol start.
        % initializes the parameter window and the scopes.

    case 'start'
        % The start action is called by the Play button. It should query
        % the protocol parameters, send any relevant data to DAQ or visual
        % hardware, and then start acquisition/playback

    case 'record'
        % The record action is called by the Record button. It
        % acts like the start action, but needs to ensure that results are
        % recorded on disk as well as in memory.

    case 'stop'
        % The stop action is called by the Stop button. It stops the
        % protocol and clears important driver settings so that subsequent
        % acquisitions (which may be called by other protocols) don't
        % generate recordings or use the wrong callbacks

    case 'destroy'
        % The destroy action is called when the module is unloaded from
        % the control structure. It should make sure devices are stopped
        % and that all important data is stored for later retrieval.

    otherwise
        % catches actions that have not had cases written for them
        error('METAPHYS:protocol:noSuchAction',...
            'No such action %s supported by protocol %s',...
            action, mfilename)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = me()
% This function is here merely for convenience so that the value 'me'
% refers to the name of this mfile (which is used in accessing parameter
% values)
out = mfilename;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = loopControl(packet)
% Many protocols are designed to loop; that is, to perform multiple repeats
% of the same experiment. With the subscription system this is accomplished
% by subscribing a specialized loop function that is called after each
% repeat.  This function will check to see if the number of repeats (if
% fixed ahead of time) is complete; will pause between repeats if this is
% required; and will then initiate another repeat. To stop looping, call
% DELETESUBSCRIPTION on the loop subscriber and then (if an immediate stop
% is necessary) call STOPDAQ.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = sweepControl
% A protocol should have a helper function that does the actual work of
% starting acquisition. This is particularly important for looping
% protocols, since this function will be called by the loop control
% function.  This function should send data to DAQ or sensory stimulation
% devices, if applicable, and then call STARTSWEEP or STARTCONTINUOUS
episodelenth = queueStimulus;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [episodelength] = queueStimulus()
% This function is responsible for queuing data prior to the beginning of a
% sweep.  For digital waveforms that need to be output through a daqdevice
% this is done with PUTINPUTDATA. This function should also compute the
% length of the episode, if it is of a predetermined length.
episodelength   = [];



