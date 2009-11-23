function obj = set(obj, fieldname, value)
%
% SET Sets values for waveformevent object
%
% event = SET(event, fieldname, value)
%
% $Id: set.m,v 1.2 2006/01/26 23:37:36 meliza Exp $

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