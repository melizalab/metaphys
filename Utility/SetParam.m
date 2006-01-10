function [] = SetParam(module, param, value)
% SETPARAM Sets the value of a module parameter. 
%
% Parameters are structures stored in the control structure, so this
% function will set the value field of the associated parameter (if it
% exists). Alternatively, if a structure is supplied, then the parameter
% will be reinitialized to the new structure (similar to INITPARAM).
% 
% [] = SETPARAM(module, paramname, value)
% 		
% 	module      - the name of the module
%   paramname   - the name of the parameter
%   value       - can be a structure or a value. If a structure, it MUST
%                 conform to PARAM_STRUCT, otherwise GETPARAM will break.
%                 If a value, sets the value field of the parameter
%                 structure. The value supplied will be automatically cast
%                 to the type of the parameter.
%
%   See Also: GETPARAM, GETPARAMSTRUCTVALUE, SETPARAMSTRUCTVALUE
%
% $Id: SetParam.m,v 1.1 2006/01/10 20:59:53 meliza Exp $
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
if ~isstruct(value)
    value   = SetParamStructValue(mpctrl.(module).params.(param), value);
end

mpctrl.(module).params.(param)  = value;

