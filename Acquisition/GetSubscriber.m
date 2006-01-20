function S = GetSubscriber(subscriber)
%
% GETSUBSCRIBER Returns a subscriber structure by name
%
% S = GETSUBSCRIBER(subscriber) - Returns [] if no such subscriber exists.
%
% See Also: SUBSCRIBER_STRUCT, PACKET_STRUCT, DATAHANDLER
%
% $Id: GetSubscriber.m,v 1.1 2006/01/20 22:02:28 meliza Exp $

global mpctrl

S = [];
if isfield(mpctrl, 'subscriber') && isstruct(mpctrl.subscriber) && ...
        isfield(mpctrl.subscriber, subscriber)
        S   = mpctrl.subscriber.(subscriber);
end