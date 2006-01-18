function [] = DeleteSubscriber(name)
%
% DELETESUBSCRIBER: Unregisters a subscriber from the acquisition system.
%
% DELETESUBSCRIBER(names) - removes subscriber(s) from the system
% DELETESUBSCRIBER('all') - removes all subscriptions
%
% See Also: ADDSUBSCRIBER, SUBSCRIBER_STRUCT
%
% $Id: DeleteSubscriber.m,v 1.1 2006/01/18 19:01:03 meliza Exp $

global mpctrl

name    = lower(name);

if isfield(mpctrl.subscriber, name)
    mpctrl.subscriber   = rmfield(mpctrl.subscriber, name);
    if isempty(fieldnames(mpctrl.subscriber))
        mpctrl.subscriber   = [];
    end
else
    warning('METAPHYS:daq:noSuchSubscriber',...
        'No such subscriber %s has been defined.', name)
end


DebugPrint('Deleted subscriber %s.', name);