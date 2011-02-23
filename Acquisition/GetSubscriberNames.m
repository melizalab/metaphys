function subscribers = GetSubscriberNames()
%
% GETSUBSCRIBERNAMES Returns a list of the current subscribers
%
% See also: SUBSCRIBER_STRUCT, PACKET_STRUCT, DATAHANDLER, EVENTHANDLER
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

global mpctrl

subscribers = [];
if isfield(mpctrl, 'subscriber') && isstruct(mpctrl.subscriber)
        subscribers     = fieldnames(mpctrl.subscriber);
end