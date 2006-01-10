function [] = InitParam(module, param, paramstruct)
%
% INITPARAM Initializes a parameter in the control structure. 
%
% In contrast to UIParams (see INITUICONTROL, GETUIPARAM, etc), Parameters
% are not necessarily connected to any GUI objects. They can be accessed
% through a PARAMFIGURE, in which case the data needs to conform to the
% structure defined in PARAM_STRUCT.
% 
% [] = INITPARAM(module, paramname, [paramstruct])
%
% module      - the module to which this parameter pertains
% paramname   - the name of the parameter
% paramstruct - the initial parameter structure. If not supplied, 
%               the parameter will be set to an empty structure 
%               (see PARAM_STRUCT)
%
%
% See Also: PARAM_STRUCT
%
%
% $Id: InitParam.m,v 1.1 2006/01/10 20:59:52 meliza Exp $
global mpctrl

param = lower(param);
module = lower(module);

% Check that the module has been initialized
if ~isfield(mpctrl, module)
    error('METAPHYS:moduleNotFound', 'No such module %s.', module);
end

if nargin < 3
    paramstruct    = param_struct;
end

mpctrl.(module).params.(param)  = paramstruct;
