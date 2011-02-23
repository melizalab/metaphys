function [] = InitParam(module, varargin)
% INITPARAM Initializes a parameter in the control structure. 
%
% In contrast to UIParams (see INITUICONTROL, GETUIPARAM, etc), Parameters
% are not necessarily connected to any GUI objects. They can be accessed
% through a PARAMFIGURE, in which case the data needs to conform to the
% structure defined in PARAM_STRUCT.
% 
% [] = INITPARAM(module, paramname, paramtype)
% [] = INITPARAM(module, paramname, paramstruct)
% [] = INITPARAM(module, namedparamstruct)
%
% module      - the module to which this parameter pertains
% paramname   - the name of the parameter
% paramtype   - sets the type of the parameter to this initial value
% paramstruct - the initial parameter structure. If not supplied, 
%               the parameter will be set to an empty structure 
%               (see PARAM_STRUCT)
% namedparamstruct - a structure of paramstructs, with the names of the
%                    parameters set by the fieldnames. 
%
%
% See also: PARAM_STRUCT
%
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE
global mpctrl

module = lower(module);

% Check that the module has been initialized
if ~isfield(mpctrl, module)
    error('METAPHYS:moduleNotFound', 'No such module %s.', module);
end

if ischar(varargin{1})
    if ischar(varargin{2})
        paramstruct = param_struct;
        paramstruct.fieldtype   = varargin{2};
    else
        paramstruct = varargin{2};
    end
    mpctrl.(module).params.(varargin{1})  = paramstruct;
else
    pnames  = fieldnames(varargin{1});
    for i = 1:length(pnames)
        mpctrl.(module).params.(pnames{i})  = varargin{1}.(pnames{i});
    end
end


