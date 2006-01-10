function [] = DeleteInstrumentTelegraph(instrument, telegraph)
%
% DELETEINSTRUMENTTELEGRAPH Removes a telegraph from an instrument. 
%
% If there are any instrumentchannels associated with the telegraph, they
% are deleted, and the telegraph structure is removed from the instrument
% control tree. This will prevent UPDATELEGRAPH from trying to read these
% channels.
%
% See Also: UPDATETELEGRAPH
%
% $Id: DeleteInstrumentTelegraph.m,v 1.1 2006/01/10 20:59:50 meliza Exp $

% just a wrapper for DeleteTelegraph
DeleteTelegraph(instrument, telegraph);