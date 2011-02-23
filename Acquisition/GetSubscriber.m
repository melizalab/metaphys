function S = GetSubscriber(subscriber)
%
% GETSUBSCRIBER Returns a subscriber structure by name
%
% S = GETSUBSCRIBER(subscriber) - Returns [] if no such subscriber exists.
%
% See also: SUBSCRIBER_STRUCT, PACKET_STRUCT, DATAHANDLER, EVENTHANDLER
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

global mpctrl

S = [];
if isfield(mpctrl, 'subscriber') && isstruct(mpctrl.subscriber) && ...
        isfield(mpctrl.subscriber, subscriber)
        S   = mpctrl.subscriber.(subscriber);
end