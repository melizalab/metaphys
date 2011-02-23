function out    = get(obj, fieldname)
%
% GET Returns the value of a field of WAVEFORMEVENT
%
% val = GET(event, fieldname) - retrieves specific field value
% val = GET(event)            - retrieves all field values
% 
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

% S       = waveformevent_struct;
% fields  = fieldnames(S);

S = struct(obj);
if nargin == 1
    out = S;
elseif isfield(S, fieldname)
    if length(S) > 1
        [out{1:length(S)}] = S.(fieldname);
    else
        out = S.(fieldname);
    end
else
    error('METAPHYS:invalidField',...
        'The field %s does not exist for class %s', fieldname, CLASSNAME)
end
