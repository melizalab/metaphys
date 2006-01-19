function subscribers = GetSubscriberNames()
%
% GETSUBSCRIBERNAMES Returns a list of the current subscribers
%
% See Also: SUBSCRIBER_STRUCT, PACKET_STRUCT, DATAHANDLER
%
% $Id: GetSubscriberNames.m,v 1.2 2006/01/20 00:04:36 meliza Exp $

global mpctrl

subscribers = [];
if isfield(mpctrl, 'subscriber') && isstruct(mpctrl.subscriber)
        subscribers     = fieldnames(mpctrl.subscriber);
end