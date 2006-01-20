function [] = DeleteModule(module)
%
% DELETEMODULE Removes a module from the control structure and deletes
% its associated figure(s).
%
% [] = DELETEMODULE(module)
%
% module (String) - module name
%
% $Id: DeleteModule.m,v 1.2 2006/01/20 22:02:34 meliza Exp $

global mpctrl

module  = lower(module);

if ~isfield(mpctrl,module)
    error('METAPHYS:moduleNotFound', 'No such module %s.', module);
end

% Call the object's destructor
if exist(module,'file') > 0
    feval(module, 'destroy')
end

% Delete the figure
fig = mpctrl.(module).fig;
delete(fig(ishandle(fig)))

% Delete any orphans
fig = FindFigure(module);
delete(fig(ishandle(fig)))

% Delete parameter figures
fig = FindFigure([module '.param']);
delete(fig(ishandle(fig)))

% Clear the module from control
mpctrl = rmfield(mpctrl, module);
