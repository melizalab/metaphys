function subscribers = GetSubscriberNames()
%
% GETSUBSCRIBERNAMES Returns a list of the current subscribers
%
% See Also: SUBSCRIBER_STRUCT, PACKET_STRUCT, DATAHANDLER
%
% $Id: GetSubscriberNames.m,v 1.1 2006/01/18 19:01:03 meliza Exp $

global mpctrl

subscribers = [];
if isfield(mpctrl, 'subscriber')
    if isstruct(mpctrl.subscriber)
        subscribers     = fieldnames(mpctrl.subscriber);
    end
end