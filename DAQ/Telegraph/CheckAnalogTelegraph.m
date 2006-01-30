function results = CheckAnalogTelegraph(instrument, object, varargin)
%
% CHECKANALOGTELEGRAPH Checks the voltage values of one or several analog
% telegraph lines, and returns the values on those lines. 
%
% Interpretation of
% the values is up to the update function associated with the particular
% instrumentation sending the telegraph.
%
% results = CHECKANALOGTELEGRAPH(instrument, object)
%
% Returns the current voltage values on OBJECT.  If OBJECT is an array,
% multiple values will be returned.
%
% See also: UPDATETELEGRAPH, ADDINSTRUMENTTELEGRAPH
%
% $Id: CheckAnalogTelegraph.m,v 1.4 2006/01/31 00:26:03 meliza Exp $

ai      = object(1).Parent;
chan    = object.Index;
% read a single sample from the daq; change this if values are too unstable
% this call will crash and burn MATLAB if hardware triggers are used and
% the object is not running. SO if this is about to happen we quick switch
% the trigger type to 'Immediate' and grab us some samples, yeah!
ttype   = ai.TriggerType;
if strcmpi(ai.TriggerType, 'hwdigital') && strcmpi(ai.Running, 'off')
    ai.TriggerType  = 'immediate';
end
val     = getsample(ai);
ai.TriggerType  = ttype;
if iscell(chan)
    results = val([chan{:}]);
else
    results = val(chan);
end

% else
%     results = [];
% end