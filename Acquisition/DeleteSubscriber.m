function [] = DeleteSubscriber(name)
%
% DELETESUBSCRIBER Unregisters a subscriber from the acquisition system.
%
% DELETESUBSCRIBER(names) - removes subscriber(s) from the system
%
% See Also: ADDSUBSCRIBER, SUBSCRIBER_STRUCT
%
% $Id: DeleteSubscriber.m,v 1.2 2006/01/19 03:14:51 meliza Exp $

global mpctrl

name    = lower(name);

if isfield(mpctrl.subscriber, name)
    mpctrl.subscriber   = rmfield(mpctrl.subscriber, name);
    if isempty(fieldnames(mpctrl.subscriber))
        mpctrl.subscriber   = [];
    end
    DebugPrint('Deleted subscriber %s.', name);
else
%     warning('METAPHYS:daq:noSuchSubscriber',...
%         'No such subscriber %s has been defined.', name)
end


