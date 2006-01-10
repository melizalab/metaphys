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
% See Also: UPDATETELEGRAPH, ADDINSTRUMENTTELEGRAPH
%
% $Id: CheckAnalogTelegraph.m,v 1.1 2006/01/10 20:59:51 meliza Exp $

ai      = object(1).Parent;
chan    = object.Channel;
% read a single sample from the daq; change this if values are too unstable
val     = getsample(ai);
results = val([chan{:}]);