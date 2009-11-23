function obj    = resetqueue(obj)
%
% RESETQUEUE Resets the parameter queue for a waveformevent
%
% RESETQUEUE(obj) returns an object with a reset parameter queue and sweep
% pointer set to 0.
%
% $Id: resetqueue.m,v 1.2 2006/01/27 01:00:09 meliza Exp $

[obj.queued_params]   = deal({});
[obj.queue_pointer]   = deal(0);