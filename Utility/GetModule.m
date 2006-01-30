function modstruct = GetModule(module)
%
% GETMODULE Returns the module substructure from the control structure. 
%
% If the module does not exist, throws an error 'METAPHYS:modulenotfound'.
% If no arguments are supplied, returns a list of all the known modules in
% the system.
%
% modstruct = GETMODULE(module)
% modlist   = GETMODULE
%
% module (String) - module name
% modstruct (struct) - module structure
% modlist (cell)  - list of all known modules
%
% See also: INITCONTROL, INITMODULE
% 
% $Id: GetModule.m,v 1.2 2006/01/30 20:04:56 meliza Exp $

global mpctrl

if nargin == 0
    modstruct   = fieldnames(mpctrl);
    % Need to subtract all the non-module modules
    modstruct   = setdiff(modstruct, fieldnames(mpctrl_default));
else

    module = lower(module);

    if ~isfield(mpctrl, module)
        error('METAPHYS:moduleNotFound', 'No such module %s.', module);
    end

    modstruct  = mpctrl.(module);
end
