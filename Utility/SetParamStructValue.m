function paramstruct = SetParamStructValue(paramstruct, value)
%
% SETPARAMSTRUCTVALUE Sets the value field in a parameter structure based
% on the existing fields in the structure. 
%
% For instance, if param.type == 'value', and the user supplies a string
% for <value>, the string will be cast to a numeric. If the type is 'list',
% the normative way to store the value is as a numeric index, so if <value>
% is a string, it will be looked up in param.choices and the value set to
% the appropriate index. If the string does not exist, an error will be
% thrown; choices should be set appropriately.
%
% See Also: GETPARAMSTRUCTVALUE, SETPARAM, PARAM_STRUCT
%
% $Id: SetParamStructValue.m,v 1.2 2006/01/21 01:22:34 meliza Exp $

NUMERIC_TYPES   = {'int8', 'int16', 'int32', 'int64',...
                   'uint8', 'uint16', 'uint32', 'uint64',...
                   'single', 'double'};

paramtype = paramstruct.fieldtype;
valuetype = class(value);

%% Cast the value according to its to and from types
switch paramtype
    case 'value'
        switch valuetype
            case 'char'
                newval  = char_value(value);
            case 'logical'
                newval  = logical_value(value);
            case 'cell'
                newval  = cell_value(value);
            case NUMERIC_TYPES
                newval  = numeric_value(value);
            otherwise
                cannotCast('numeric', valuetype)
        end
    case 'string'
        switch valuetype
            case 'char'
                newval  = value;
            case NUMERIC_TYPES
                newval  = value_string(value);
            case 'cell'
                newval  = cell_string(value);
            otherwise
                cannotCast('string', valuetype)
        end
    case 'list'
        switch valuetype
            case NUMERIC_TYPES
                value   = fix(value(1));
                if value > length(paramstruct.choices)
                    error('METAPHYS:setparamstructvalue:valueOutOfRange',...
                        'No choice exists with value %d', value)
                end
                newval  = value;
            case 'char'
                newval   = string_list(value, paramstruct.choices);
            case 'cell'
                % list only allows single choices
                error('METAPHYS:setparamstructvalue:valueOutOfRange',...
                    'Only single choices are accepted by list parameters.')
            otherwise
                cannotCast('list', valuetype)
        end
    otherwise
        % no casting is done for other parameter types
        newval  = value;
end
%% Set the value in the structure
paramstruct.value   = newval;


function [] = cannotCast(totype, fromtype)
% Generates an error message for cast errors
switch nargin
    case 0
        error('METAPHYS:invalidCast', 'Unable to cast variable.')
    case 1
        error('METAPHYS:invalidCast', 'Unable to cast to %s', totype)
    otherwise
        error('METAPHYS:invalidCast', 'Unable to cast %s to %s',...
            fromtype, totype)
end
% Varous functions for casting:

function out    = char_value(value)
out = str2num(value);

function out    = logical_value(value)
out = double(value);

function out    = numeric_value(value)
% all numeric classes are cast to double, just to keep things simple
out = double(value);

function out    = cell_value(value)
% calls CELL2MAT, which  is highly unstable and may throw an error if the
% dimensions are wrong.
try
    mat     = cell2mat(value);
catch
    cannotCast('matrix', 'cell');
end
out     = char_value(mat);

function out    = value_string(value)
out = num2str(value);

function out    = cell_string(value)
% unlike CELL2MAT, CHAR is pretty robust
out = char(value);

function out    = string_list(value, choices)
index   = strmatch(value, choices);
if isempty(index)
    error('METAPHYS:setparamstructvalue:valueOutOfRange',...
        'The option %s does not exist for this parameter.', value)
end
out     = index(1);