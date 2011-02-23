function obj    = resetqueue(obj)
%
% RESETQUEUE Resets the parameter queue for a waveformevent
%
% RESETQUEUE(obj) returns an object with a reset parameter queue and sweep
% pointer set to 0.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

[obj.queued_params]   = deal({});
[obj.queue_pointer]   = deal(0);