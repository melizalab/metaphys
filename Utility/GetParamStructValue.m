function out = GetParamStructValue(paramstruct, value_format)
%
% GETPARAMSTRUCTVALUE Retrieves the value from a parameter structure. 
%
% Parses a paramstruct structure and returns a useful value. 
%
% USAGE: out = GETPARAMSTRUCTVALUE(paramstruct, [value_format])
%
% paramstruct   - the parameter structure
% value_format  - for lists, value_format can be {'String'} or 'Value',
%                 which returns either the selected item or the numerical
%                 index of the selected item in the .choices field. For
%                 non-lists, this argument has no effect; values are cast
%                 according to the field type.
%
% out           - the output value, which can be numeric or a character string
%
% See Also:
%   PARAM_STRUCT, GETPARAM
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

VALUE_FORMAT    = 'String';
if nargin < 2
    value_format    = VALUE_FORMAT;
end

out = paramstruct.value;
if strcmpi(paramstruct.fieldtype, 'list')
    % Choices are normatively stored as values
    if strcmpi(value_format, VALUE_FORMAT)
        out = paramstruct.choices{out};
    end
end            