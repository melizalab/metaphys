function [] = SetParam(module, param, field, value)
% SETPARAM Sets the value of a module parameter. 
%
% Parameters are structures stored in the control structure, so this
% function will set the value field of the associated parameter (if it
% exists). Alternatively, if a structure is supplied, then the parameter
% will be reinitialized to the new structure (similar to INITPARAM).
% 
% [] = SETPARAM(module, paramname, value)
% [] = SETPARAM(module, paramname, field, value)
% 		
% 	module      - the name of the module
%   paramname   - the name of the parameter
%   field       - the field to change (default value)
%   value       - can be a structure or a value. If a structure, it MUST
%                 conform to PARAM_STRUCT, otherwise GETPARAM will break.
%                 If a value, sets the specified field of the parameter
%                 structure. If field is 'value', value supplied will be automatically cast
%                 to the type of the parameter.
%
%   See also: GETPARAM, GETPARAMSTRUCTVALUE, SETPARAMSTRUCTVALUE
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE
global mpctrl

param = lower(param);
module = lower(module);

%% Check that the module has been initialized
if ~isfield(mpctrl, module)
    error('METAPHYS:moduleNotFound', 'No such module %s.', module);
end

%% Check that the parameter exists
if ~isfield(mpctrl.(module).params, param)
    error('METAPHYS:paramNotFound', 'No such parameter %s in module %s.',...
        param, module);
end

%% Set the parameter
if nargin == 3
    value = field;
    if ~isstruct(value)
        value   =  SetParamStructValue(mpctrl.(module).params.(param), value);
    end
    mpctrl.(module).params.(param)  = value;
else
    mpctrl.(module).params.(param).(field) = value;
end
