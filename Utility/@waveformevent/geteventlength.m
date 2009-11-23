function times  = geteventlength(obj)
%
% GETEVENTLENGTH Returns the min and max time that the event will affect
%
% GETEVENTLENGTH(obj) returns a 2 element vector with the minimum onset
% time and the maximum offset time. This assumes that if user_func is set
% that this function will handle the onset and duration parameters in a
% well-regulated manner; that is, not allowing the effects of the event to
% move outside these times.
%
% Can take an array of objects, in which case the returned value will be an
% Nx2 array.
%
% $Id: geteventlength.m,v 1.1 2006/01/26 23:37:35 meliza Exp $

for i = 1:length(obj)
    if isvalid(obj(i))
        [onset ampl dur]   = getvaluerotation(obj(i));
        times(i,1)         = min(onset);
        times(i,2)         = max(onset) + max(dur);
    else
        times(i,:)         = [NaN NaN];
    end
end