function subscriber = GetSubscriber(subscribernames)
%
% GETSUBSCRIBER Returns a subscriber structure referred to by its tag
%
% GETSUBSCRIBER(subscribername) - Returns the subscriber structure(s) named
%                                 <subscribername>
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

global mpctrl

subscriber  = GetFields(mpctrl.subscriber, subscribernames);
subscriber  = StructFlatten(subscriber);
