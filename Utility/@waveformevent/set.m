function obj = set(obj, fieldname, value)
%
% SET Sets values for waveformevent object
%
% event = SET(event, fieldname, value)
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

error(nargchk(3,3,nargin,'struct'))
if isfield(struct(obj), fieldname)
    % condition any numeric values
    if isnumeric(value)
        if size(value,1) == 1
            value   = value(:);
        end
    end
    [obj.(fieldname)] = deal(value);
else
    error('METAPHYS:invalidField',...
        'The field %s does not exist for class %s', fieldname, CLASSNAME)
end