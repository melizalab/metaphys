function obj    = saveobj(obj)
%
% SAVEOBJ Removes private and transient fields from object before saving
%
% event = SAVEOBJ(event)
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

fn  = TRANSIENT_FIELDS;
for i = 1:length(fn)
    obj.(fn{i}) = [];
end
