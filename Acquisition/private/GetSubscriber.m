function subscriber = GetSubscriber(subscribernames)
%
% GETSUBSCRIBER Returns a subscriber structure referred to by its tag
%
% GETSUBSCRIBER(subscribername) - Returns the subscriber structure(s) named
%                                 <subscribername>
%
% $Id: GetSubscriber.m,v 1.1 2006/01/18 19:01:03 meliza Exp $

if iscell(subscribernames)
    for i = 1:length(subscribernames)
        subscriber(i)  = getstructure(subscribernames{i});
    end
else
    subscriber     = getstructure(subscribernames);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function subscriber  = getstructure(subscribername)
global mpctrl
subscribername  = lower(subscribername);

if ~isfield(mpctrl.subscriber, subscribername)
    error('METAPHYS:daq:subscriberNotFound',...
        'No subscriber %s exists.',subscribername)
end

subscriber = mpctrl.subscriber.(subscribername);