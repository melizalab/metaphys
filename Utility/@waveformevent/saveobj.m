function obj    = saveobj(obj)
%
% SAVEOBJ Removes private and transient fields from object before saving
%
% event = SAVEOBJ(event)
%
% $Id: saveobj.m,v 1.1 2006/01/27 00:40:12 meliza Exp $

fn  = TRANSIENT_FIELDS;
for i = 1:length(fn)
    obj.(fn{i}) = [];
end
