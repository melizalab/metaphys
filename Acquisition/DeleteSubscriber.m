function [] = DeleteSubscriber(name)
%
% DELETESUBSCRIBER Unregisters a subscriber from the acquisition system.
%
% DELETESUBSCRIBER(names) - removes subscriber(s) from the system
%
% See also: ADDSUBSCRIBER, SUBSCRIBER_STRUCT
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

global mpctrl

name    = lower(name);

if isfield(mpctrl.subscriber, name)
    mpctrl.subscriber   = rmfield(mpctrl.subscriber, name);
    if isempty(fieldnames(mpctrl.subscriber))
        mpctrl.subscriber   = [];
    end
    DebugPrint('Deleted subscriber %s.', name);
end


