function [] = DeleteSubscriber(name)
%
% DELETESUBSCRIBER Unregisters a subscriber from the acquisition system.
%
% DELETESUBSCRIBER(names) - removes subscriber(s) from the system
%
% See also: ADDSUBSCRIBER, SUBSCRIBER_STRUCT
%
% $Id: DeleteSubscriber.m,v 1.3 2006/01/30 20:04:33 meliza Exp $

global mpctrl

name    = lower(name);

if isfield(mpctrl.subscriber, name)
    mpctrl.subscriber   = rmfield(mpctrl.subscriber, name);
    if isempty(fieldnames(mpctrl.subscriber))
        mpctrl.subscriber   = [];
    end
    DebugPrint('Deleted subscriber %s.', name);
end


