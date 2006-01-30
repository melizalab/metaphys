function subscribers = GetSubscriberNames()
%
% GETSUBSCRIBERNAMES Returns a list of the current subscribers
%
% See also: SUBSCRIBER_STRUCT, PACKET_STRUCT, DATAHANDLER, EVENTHANDLER
%
% $Id: GetSubscriberNames.m,v 1.3 2006/01/30 20:04:34 meliza Exp $

global mpctrl

subscribers = [];
if isfield(mpctrl, 'subscriber') && isstruct(mpctrl.subscriber)
        subscribers     = fieldnames(mpctrl.subscriber);
end