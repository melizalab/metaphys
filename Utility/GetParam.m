function out = GetParam(module, param, mode)
%
% GETPARAM Accesses the contents of a non-GUI parameter. 
%
% Parameters should conform to the structure defined in PARAM_STRUCT. In
% this case the value of the parameter will be returned.
%
% out = GETPARAM(module, [param, [mode]])
%
%   module - the module name
%   param - the parameter name. If this is empty, the entire param
%           structure for the module is returned (unparsed)
%   mode  - if 'struct', the param structure is not parsed (default is
%              to return the value
%   out - the param structure or value
%
%   See Also: SETPARAM, INITPARAM, PARAMFIGURE, GETPARAMSTRUCTVALUE
% 
%   $Id: GetParam.m,v 1.2 2006/01/24 21:42:18 meliza Exp $
%
RETURN_STRUCT   = 'struct';

global mpctrl

module = lower(module);

if ~isfield(mpctrl, module)
    error('METAPHYS:moduleNotFound', 'No such module %s.', module);
end

if nargin < 2
    out   = mpctrl.(module).params;
    return
else
    if ~isfield(mpctrl.(module).params, param)
        error('METAPHYS:paramNotFound', 'No such param %s in module %s.',...
            param, module);
    end
    paramstruct = mpctrl.(module).params.(param);
end

% return structure if that's what's asked for
if nargin > 3
    if strcmpi(mode, RETURN_STRUCT)
        out = paramstruct;
        return
    end
end

out = GetParamStructValue(paramstruct);
