function S = GetSubscriber(subscriber)
%
% GETSUBSCRIBER Returns a subscriber structure by name
%
% S = GETSUBSCRIBER(subscriber) - Returns [] if no such subscriber exists.
%
% See also: SUBSCRIBER_STRUCT, PACKET_STRUCT, DATAHANDLER, EVENTHANDLER
%
% $Id: GetSubscriber.m,v 1.2 2006/01/30 20:04:34 meliza Exp $

global mpctrl

S = [];
if isfield(mpctrl, 'subscriber') && isstruct(mpctrl.subscriber) && ...
        isfield(mpctrl.subscriber, subscriber)
        S   = mpctrl.subscriber.(subscriber);
end