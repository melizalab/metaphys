function [S] = StructConstruct(fields, defaults, required, arguments)
%
% STRUCTCONSTRUCT Generic constructor for predefined structures.
%
% S = STRUCTCONSTRUCT(fields, defaults, required, arguments)
%
% Acts as a generic constructor for a structure with a certain number of
% defined fields. These fields and their default values are given by the
% first two arguments, and <required> is a scalar indicating how many
% (starting from the beginning) are required. If an insufficient number of
% arguments are supplied (as a cell array in <arguments>) an error is
% thrown; if not, the default values will be replaced by the supplied
% values and the structure returned. If no arguments are supplied, then the
% constructor returns an empty structure.
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

nargs   = size(arguments,2);
if nargs > 0
    if nargs < required
        error('METPHYS:invalidConstructor',...
            'At least %d arguments are required.', required);
    elseif nargs > size(fields,2)
        error('METPHYS:invalidConstructor',...
            'Structure only has %d fields.', size(fields,2));
    end
end


if nargs == size(fields,2)
    C   = arguments;
else
    C   = {arguments{:} defaults{nargs+1:end}};
end
S   = cell2struct(C, fields, 2);