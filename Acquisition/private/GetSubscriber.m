function subscriber = GetSubscriber(subscribernames)
%
% GETSUBSCRIBER Returns a subscriber structure referred to by its tag
%
% GETSUBSCRIBER(subscribername) - Returns the subscriber structure(s) named
%                                 <subscribername>
%
% $Id: GetSubscriber.m,v 1.2 2006/01/19 03:14:52 meliza Exp $

global mpctrl

subscriber  = GetFields(mpctrl.subscriber, subscribernames);
subscriber  = StructFlatten(subscriber);
